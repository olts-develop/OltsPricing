-- -----------------------------------------------------------------------------
-- EarlyBooking
-- -----------------------------------------------------------------------------

-- TODO: die AbTage/BisTage in Relation zu dem Anfangstag der Buchung ODER den
--       Anfangstag des EarlyBooking, dies im Speziellen, werden im SQL unten noch nicht berücksichtigt.

drop function func_eb2_tbl @

CREATE FUNCTION func_eb2_tbl (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  NR INTEGER
  ,PRICE DECIMAL(10, 2)
  ,TOTAL DECIMAL(10, 2)
  ,TYPE1 VARCHAR(20) -- PDP, APDP, OT, SO, EB
  ,TYPE2 VARCHAR(20) -- ADULT, CHD1, CHD2
  ,FROMDATE DATE
  ,TODATE DATE
  ,DESCID INTEGER
  ,P_SEQ VARCHAR(20)
  ,PRICETYPE VARCHAR(10)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  --  DECLARE childbirthdate1 DATE ;
  --  DECLARE childbirthdate2 DATE ;
  --  DECLARE childbirthdate3 DATE ;
  --  DECLARE childbirthdate4 DATE ;
  DECLARE returndateminus1 DATE;
  DECLARE daysbetweenstartend INTEGER;

  --  SET childbirthdate1 = p_childbirthdate1 ;
  --  SET childbirthdate2 = p_childbirthdate2 ;
  --  SET childbirthdate3 = p_childbirthdate3 ;
  --  SET childbirthdate4 = p_childbirthdate4 ;
  SET returndateminus1 = p_returndate - 1 DAY;
  SET daysbetweenstartend = days(p_returndate) - days(p_startdate);

  RETURN
  WITH earlybookinglist1(id, datefrom, effectivedatefrom, dateto, effectivedateto, PERCENT, foralldays, fromday, today, seqdate, daterownr, ebrownr) AS (
      SELECT id
        ,datefrom
        ,(
          CASE 
            WHEN datefrom < p_startdate
              THEN p_startdate
            ELSE datefrom
            END
          ) AS effectivedatefrom
        ,dateto
        ,(
          CASE 
            WHEN dateto > returndateminus1
              THEN returndateminus1
            ELSE dateto
            END
          ) AS effectivedateto
        ,coalesce(PERCENT, 0) AS PERCENT
        ,coalesce(foralldays, 0) AS foralldays
        ,fromday
        ,today
        ,tmpday
        ,ROW_NUMBER() OVER (
          PARTITION BY id ORDER BY id ASC
            ,tmpday ASC
          ) AS daterownr
        ,RANK() OVER (
          PARTITION BY id ORDER BY PERCENT DESC
            ,today DESC
            ,id ASC
          ) AS ebrownr
      FROM tooearlybookings
        ,tootmpday
      WHERE (
          itemkey
          ,tocode
          ,itemtype
          ,currency
          ) = (
          p_itemkey
          ,p_tocode
          ,p_itemtype
          ,p_currency
          )
        AND tmpday BETWEEN p_startdate
          AND returndateminus1
        AND tmpday BETWEEN datefrom
          AND dateto
        AND PERCENT <> 0
        AND fromday <= daysbetweenstartend
        AND (
          (
            daysbeforedeparturefrom = 0
            AND daysbeforedepartureto = 0
            AND p_currentdate BETWEEN datebeforedeparturefrom
              AND datebeforedepartureto
            )
          OR (
            -- ( daysbeforedeparturefrom <> 0 OR daysbeforedepartureto <> 0 )
            daysbeforedeparturefrom + daysbeforedepartureto > 0
            AND p_currentdate BETWEEN p_startdate - daysbeforedeparturefrom days
              AND p_startdate - daysbeforedepartureto days
            )
          )
        AND (
          (
            (
              (
                p_startdate BETWEEN datefrom
                  AND dateto
                AND returndateminus1 BETWEEN datefrom
                  AND dateto
                )
              OR (
                datefrom BETWEEN p_startdate
                  AND returndateminus1
                AND dateto BETWEEN p_startdate
                  AND p_returndate - 1 DAY
                )
              OR (
                p_startdate BETWEEN datefrom
                  AND dateto
                AND returndateminus1 > dateto
                )
              OR (
                returndateminus1 BETWEEN datefrom
                  AND dateto
                AND p_startdate < datefrom
                )
              )
            AND startdaterelevant = 0
            AND enddaterelevant = 0
            )
          OR (
            datefrom <= p_startdate
            AND dateto >= p_startdate
            AND startdaterelevant = 1
            AND enddaterelevant = 0
            )
          OR (
            datefrom <= returndateminus1
            AND dateto >= returndateminus1
            AND startdaterelevant = 0
            AND enddaterelevant = 1
            )
          OR (
            datefrom <= p_startdate
            AND dateto >= returndateminus1
            AND startdaterelevant = 1
            AND enddaterelevant = 1
            )
          )
        AND SUBSTR(weekdaysvalid, DAYOFWEEK_ISO(DATE (tmpday)), 1) = '1'
        AND (
          foralldays = 1
          OR (
            foralldays = 0
            AND fromday = 0
            AND today = 0
            )
          OR (
            foralldays = 0
            AND DAYS(CASE 
                WHEN dateto > returndateminus1
                  THEN returndateminus1
                ELSE dateto
                END) - DAYS(CASE 
                WHEN datefrom < p_startdate
                  THEN p_startdate
                ELSE datefrom
                END) BETWEEN fromday
              AND today
            )
          )
      )
    ,earlybookinglist2(id, datefrom, effectivedatefrom, dateto, effectivedateto, PERCENT, foralldays, fromday, today, seqdate, total, type2) AS (
      SELECT id
        ,datefrom
        ,effectivedatefrom
        ,dateto
        ,effectivedateto
        ,PERCENT
        ,foralldays
        ,fromday
        ,today
        ,seqdate
        ,X.total
        ,x.type2
      FROM earlybookinglist1
        --  ,TABLE( func_pricing3_tbl (p_tocode, p_itemkey, p_startdate, p_returndate, p_currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4 ) ) AS X
        ,TABLE (func_pricing3_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS X
      WHERE ebrownr = 1
        AND X.type1 IN (
          'PDP'
          ,'APDP'
          ,'SO'
          )
        AND X.fromdate = seqdate
        AND X.todate = seqdate
        AND X.notspecialrelevant = 0
        AND (
          foralldays = 1
          OR (
            foralldays = 0
            AND fromday = 0
            AND today = 0
            )
          OR (
            foralldays = 0
            AND daterownr BETWEEN fromday
              AND today
            )
          )
      )

  SELECT 1
    ,SUM(coalesce(earlybookinglist2.total, 0) * coalesce(earlybookinglist2.PERCENT, 0) / 100) AS price
    ,SUM(coalesce(earlybookinglist2.total, 0) * coalesce(earlybookinglist2.PERCENT, 0) / 100) AS total
    ,'EB'
    ,earlybookinglist2.type2
    ,earlybookinglist2.seqdate
    ,earlybookinglist2.seqdate
    ,MAX(tooearlybookings.descid)
    ,MAX(tooearlybookings.p_seq)
    ,MAX(tooearlybookings.pricetype)
  FROM earlybookinglist2
    ,tooearlybookings
  WHERE earlybookinglist2.id = tooearlybookings.id
    AND currency = p_currency
  GROUP BY earlybookinglist2.seqdate
    ,earlybookinglist2.type2;
END
@


-- 'STOGVA15485'


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

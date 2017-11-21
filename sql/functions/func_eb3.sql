-- -----------------------------------------------------------------------------
-- EarlyBooking Percent = 0
-- -----------------------------------------------------------------------------
-- TODO: die AbTage/BisTage in Relation zu dem Anfangstag der Buchung ODER den
--       Anfangstag des EarlyBooking, dies im Speziellen, werden im SQL unten noch nicht berücksichtigt.
drop function func_eb3_tbl @

CREATE FUNCTION func_eb3_tbl (
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
  ,TYPE1 VARCHAR(20) -- PDP, APDP, OT, SO, EB, EB2
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

  SELECT p_nradults
    ,coalesce(ADDAMOUNT, 0)
    ,coalesce(ADDAMOUNT, 0) * p_nradults
    ,'EB2'
    ,'ADULT'
    ,(
      CASE 
        WHEN datefrom < p_startdate
          THEN p_startdate
        ELSE datefrom
        END
      ) AS effectivedatefrom
    ,(
      CASE 
        WHEN dateto > returndateminus1
          THEN returndateminus1
        ELSE dateto
        END
      ) AS effectivedateto
    ,tooearlybookings.descid as descid
    ,tooearlybookings.p_seq as p_seq
    ,tooearlybookings.pricetype as pricetype
  FROM tooearlybookings
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
    AND datefrom <= p_startdate
    AND dateto >= returndateminus1
    AND PERCENT = 0
    AND fromday <= daysbetweenstartend
    AND (
      (
        daysbeforedeparturefrom = 0
        AND daysbeforedepartureto = 0
        AND current date BETWEEN datebeforedeparturefrom
          AND datebeforedepartureto
        )
      OR (
        -- ( daysbeforedeparturefrom <> 0 OR daysbeforedepartureto <> 0 )
        daysbeforedeparturefrom + daysbeforedepartureto > 0
        AND current date BETWEEN p_startdate - daysbeforedeparturefrom days
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
              AND returndateminus1
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
                END) +1 BETWEEN fromday
              AND today
            )
          )
;

END
@

-- 'TOUWAL27943'
-- MOD:rb:2017-11-21
-- There was a problem with the calculation of the earlybooking. The calculation 
-- if the period of the price fits into the fromday/today range was off by one.
-- Reported by AK (ACT).
-- Replaced a "returndate -1 day" with the appropriate variable.
-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

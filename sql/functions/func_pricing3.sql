-- -----------------------------------------------------------------------------
-- Pricing: PerDayPrice, AddPerDayPrice, OneTime and SpecialOffer
-- -----------------------------------------------------------------------------

drop function func_pricing3_tbl @

CREATE FUNCTION func_pricing3_tbl (
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
  ,NOTSPECIALRELEVANT INTEGER
  ,DESCID INTEGER
  ,P_SEQ VARCHAR(20)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  --  DECLARE childbirthdate1 DATE;
  --  DECLARE childbirthdate2 DATE;
  --  DECLARE childbirthdate3 DATE;
  --  DECLARE childbirthdate4 DATE;
  --  SET childbirthdate1 = p_childbirthdate1 ;
  --  SET childbirthdate2 = p_childbirthdate2 ;
  --  SET childbirthdate3 = p_childbirthdate3 ;
  --  SET childbirthdate4 = p_childbirthdate4 ;
  RETURN
  WITH childtemptable(chdnr, chdnrstring, bd) AS (
      VALUES (
        0
        ,'0'
        ,cast(NULL AS DATE)
        )
        ,(
        1
        ,'1'
        ,p_childbirthdate1
        )
        ,(
        2
        ,'2'
        ,p_childbirthdate2
        )
        ,(
        3
        ,'3'
        ,p_childbirthdate3
        )
        ,(
        4
        ,'4'
        ,p_childbirthdate4
        )
      )

  SELECT nr
    ,price
    ,total
    ,type1
    ,type2
    ,fromdate
    ,todate
    ,notspecialrelevant
    ,descid
    ,p_seq
  FROM TABLE (func_all_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS pricing
  
  UNION ALL
  
  SELECT (
      CASE CHILDCHILDNR
        WHEN 0
          THEN p_nradults
        ELSE 1
        END
      ) AS NR
    ,coalesce(so.SPECIAL, 0) - coalesce(so.ADDAMOUNT, 0) AS PRICE
    ,(
      CASE CHILDCHILDNR
        WHEN 0
          THEN p_nradults
        ELSE 1
        END
      ) * ((coalesce(so.SPECIAL, 0) - coalesce(so.ADDAMOUNT, 0))) AS TOTAL
    ,'SO'
    ,(
      CASE CHILDCHILDNR
        WHEN 0
          THEN 'ADT'
        ELSE 'CHD' || VARCHAR(CHILDCHILDNR)
        END
      )
    ,so.SEQDATE AS FROMDATE
    ,so.SEQDATE AS TODATE
    ,0 AS NOTSPECIALRELEVANT
    ,so.DESCID
    ,so.P_SEQ
  FROM TABLE (func_spof3_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS so;
END
@



drop function func_pricing3 @

CREATE FUNCTION func_pricing3 (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE -- start of booking period
  ,p_returndate DATE -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS DECIMAL(10, 2) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  --  DECLARE childbirthdate1 DATE;
  --  DECLARE childbirthdate2 DATE;
  --  DECLARE childbirthdate3 DATE;
  --  DECLARE childbirthdate4 DATE;
  --  SET childbirthdate1 = p_childbirthdate1 ;
  --  SET childbirthdate2 = p_childbirthdate2 ;
  --  SET childbirthdate3 = p_childbirthdate3 ;
  --  SET childbirthdate4 = p_childbirthdate4 ;
  RETURN

  SELECT coalesce(sum(x.TOTAL), 0)
  FROM TABLE (func_pricing3_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x;
END
@


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

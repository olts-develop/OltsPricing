-- -----------------------------------------------------------------------------
-- Pricing
-- -----------------------------------------------------------------------------

drop function func_pricing2_tbl @

CREATE FUNCTION func_pricing2_tbl (
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

  SELECT nr
    ,price
    ,total
    ,type1
    ,type2
    ,fromdate
    ,todate
    ,descid
    ,p_seq
  FROM TABLE (func_pricing3_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS pricing
  
  UNION ALL
  
  SELECT NR
    ,PRICE
    ,TOTAL
    ,'EB'
    ,TYPE2
    ,FROMDATE
    ,TODATE
    ,DESCID
    ,P_SEQ
  FROM TABLE (func_eb2_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS pricing;
END
@




drop function func_pricing2 @

CREATE FUNCTION func_pricing2 (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL -- start of booking period
  ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
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
  FROM TABLE (func_pricing2_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x;
END
@


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

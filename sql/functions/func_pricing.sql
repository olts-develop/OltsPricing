-- -----------------------------------------------------------------------------
-- Function name: *func_pricing_tbl*

-- This function takes into account the occuancy in a room and assigns children
-- as adults should this be necessary. In a double room with one adult and one
-- child the child will be treated as an adult via the "func_roomvalid"
-- function.
-- Note: this function is only useful for a hotel pricing!
-- -----------------------------------------------------------------------------

drop function func_pricing_tbl @

CREATE FUNCTION func_pricing_tbl (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
  ,TYPE2 VARCHAR(20) -- ADT, CHD1, CHD2, CHD3, CHD4
  ,FROMDATE DATE
  ,TODATE DATE
  ,DESCID INTEGER
  ,P_SEQ VARCHAR(20)
  ,PRICETYPE VARCHAR(10)
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
    ,pricetype
  FROM TABLE (func_roomvalid(p_tocode, p_itemkey, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
    ,TABLE (func_pricing2_tbl(p_tocode, p_itemkey, 'H', p_startdate, p_returndate, p_currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency)) AS pricing
  WHERE func_test_price(p_tocode, p_itemkey, 'H', p_startdate, p_returndate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency) = 'OK';
END
@


--
-- select * from TABLE( func_pricing_tbl( '', '13800', date('2015-09-12'), date('2015-09-19'), current date, 2 ) ) as pricing order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc
--
-- select
--    *
--  from
--    TABLE( func_pricing_tbl( 'IMHO', 'TUIXYA192344', date('2016-10-03'), date('2016-10-12'), current date, 1, cast('2010-01-01' as DATE), cast('2010-01-01' as DATE) ) ) as pricing
-- order by
--   (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc
--   ,TYPE2 asc
--   ,FROMDATE asc
--
-- NR  PRICE    TOTAL    TYPE1  TYPE2  FROMDATE    TODATE
-- --  -------  -------  -----  -----  ----------  ----------
--  2   348.00   696.00   PDP     ADULT   2016-10-03 2016-10-03
--  2   348.00   696.00   PDP     ADULT   2016-10-04 2016-10-04
--  2   348.00   696.00   PDP     ADULT   2016-10-05 2016-10-05
--  2   348.00   696.00   PDP     ADULT   2016-10-06 2016-10-06
--  2   348.00   696.00   PDP     ADULT   2016-10-07 2016-10-07
--  2   348.00   696.00   PDP     ADULT   2016-10-08 2016-10-08
--  2   348.00   696.00   PDP     ADULT   2016-10-09 2016-10-09
--  2   348.00   696.00   PDP     ADULT   2016-10-10 2016-10-10
--  2   348.00   696.00   PDP     ADULT   2016-10-11 2016-10-11
--  2   348.00  -696.00   SO      ADULT   2016-10-08 2016-10-08
--  2     0.00     0.00   SO      ADULT   2016-10-09 2016-10-09
--  2   -34.80   -69.60   EB      ADULT   2016-10-03 2016-10-03
--  2   -34.80   -69.60   EB      ADULT   2016-10-04 2016-10-04
--  2   -34.80   -69.60   EB      ADULT   2016-10-05 2016-10-05
--  2   -34.80   -69.60   EB      ADULT   2016-10-06 2016-10-06
--  2   -34.80   -69.60   EB      ADULT   2016-10-07 2016-10-07
--  2     0.00     0.00   EB      ADULT   2016-10-08 2016-10-08
--  2   -34.80   -69.60   EB      ADULT   2016-10-09 2016-10-09
--  2   -34.80   -69.60   EB      ADULT   2016-10-10 2016-10-10
--  2   -34.80   -69.60   EB      ADULT   2016-10-11 2016-10-11
--  1     0.00     0.00   EB      CHD1    2016-10-03 2016-10-03
--  1     0.00     0.00   EB      CHD1    2016-10-04 2016-10-04
--  1     0.00     0.00   EB      CHD1    2016-10-05 2016-10-05
--  1     0.00     0.00   EB      CHD1    2016-10-06 2016-10-06
--  1     0.00     0.00   EB      CHD1    2016-10-07 2016-10-07
--  1     0.00     0.00   EB      CHD1    2016-10-08 2016-10-08
--  1     0.00     0.00   EB      CHD1    2016-10-09 2016-10-09
--  1     0.00     0.00   EB      CHD1    2016-10-10 2016-10-10
--  1     0.00     0.00   EB      CHD1    2016-10-11 2016-10-11
--
--


drop function func_pricing_tblch @

CREATE FUNCTION func_pricing_tblch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_returndate VARCHAR(10) DEFAULT '' -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
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

  DECLARE startdate DATE;
  DECLARE returndate DATE;
  DECLARE currentdate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate, '') AS DATE);
  SET returndate = cast(nullif(p_returndate, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(p_currentdate, '') AS DATE), CURRENT DATE);
  SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);

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
    ,pricetype
  FROM TABLE (func_roomvalid(p_tocode, p_itemkey, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency)) AS x
    ,TABLE (func_pricing2_tbl(p_tocode, p_itemkey, 'H', startdate, returndate, currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency)) AS pricing
  WHERE func_test_price(p_tocode, p_itemkey, 'H', p_startdate, p_returndate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency) = 'OK';
END
@


--
-- select * from TABLE( func_pricing_tblch( 'IMHO', 'TUIXYA192344', '2016-10-03', '2016-10-12', '', 2, '', '' ) ) as pricing
--
-- The following also works correctly passing cast(NULL as char(1)) as a parameter:
-- select
--   *
-- from
--   TABLE( func_pricing_tblch( '', 'TUIXYA192344', '2016-10-03', '2016-10-12', cast(NULL as char(1)), 2, '', '' ) ) as pricing
--
--  NR  PRICE    TOTAL    TYPE1  TYPE2  FROMDATE    TODATE
--  --  -------  -------  -----  -----  ----------  ----------
--   2  348.00  696.00 PDP   ADULT 2016-10-03 2016-10-03
--   2  348.00  696.00 PDP   ADULT 2016-10-04 2016-10-04
--   2  348.00  696.00 PDP   ADULT 2016-10-05 2016-10-05
--   2  348.00  696.00 PDP   ADULT 2016-10-06 2016-10-06
--   2  348.00  696.00 PDP   ADULT 2016-10-07 2016-10-07
--   2  348.00  696.00 PDP   ADULT 2016-10-08 2016-10-08
--   2  348.00  696.00 PDP   ADULT 2016-10-09 2016-10-09
--   2  348.00  696.00 PDP   ADULT 2016-10-10 2016-10-10
--   2  348.00  696.00 PDP   ADULT 2016-10-11 2016-10-11
--   2 -348.00 -696.00 SO    ADULT 2016-10-08 2016-10-08
--   2    0.00    0.00 SO    ADULT 2016-10-09 2016-10-09
--   2  -34.80  -69.60 EB    ADULT 2016-10-03 2016-10-03
--   2  -34.80  -69.60 EB    ADULT 2016-10-04 2016-10-04
--   2  -34.80  -69.60 EB    ADULT 2016-10-05 2016-10-05
--   2  -34.80  -69.60 EB    ADULT 2016-10-06 2016-10-06
--   2  -34.80  -69.60 EB    ADULT 2016-10-07 2016-10-07
--   2    0.00    0.00 EB    ADULT 2016-10-08 2016-10-08
--   2  -34.80  -69.60 EB    ADULT 2016-10-09 2016-10-09
--   2  -34.80  -69.60 EB    ADULT 2016-10-10 2016-10-10
--   2  -34.80  -69.60 EB    ADULT 2016-10-11 2016-10-11


drop function func_pricing @

CREATE FUNCTION func_pricing (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
  FROM TABLE (func_pricing_tbl(p_tocode, p_itemkey, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x;
END
@


--
-- select
--   func_pricing( 'IMHO', 'TUIXYA192344', date('2016-10-03'), date('2016-10-12'), current date, 2, cast(NULL as DATE), cast(NULL as DATE) ) as TOTAL
-- from
--    sysibm.sysdummy1
--
--  TOTAL
--  -------
--  5011.20
--


drop function func_pricingch @

CREATE FUNCTION func_pricingch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT '' -- start of booking period
  ,p_returndate VARCHAR(10) DEFAULT '' -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS DECIMAL(10, 2) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;
  DECLARE currentdate DATE;

  SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(p_currentdate, '') AS DATE), CURRENT DATE);

  RETURN

  SELECT coalesce(sum(x.TOTAL), 0)
  FROM TABLE (func_pricing_tbl(p_tocode, p_itemkey, cast(nullif(p_startdate, '') AS DATE), cast(nullif(p_returndate, '') AS DATE), currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency)) AS x;
END
@




--
-- select func_pricingch( 'IMHO', 'TUIXYA192344', '2016-10-03', '2016-10-12', '', 2, '', '' ) as TOTAL from sysibm.sysdummy1
--
--  TOTAL
--  -------
--  5011.20
--


-- select * from TABLE( func_pricing_tbl( '', 'STOGVA61793', date('2015-10-03'), date('2015-10-12'), current date, 1 ) ) as pricing
-- order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc

-- select * from TABLE( func_pricing_tblch( '', 'STOGVA61793', '2015-10-03', '2015-10-12', '', 1 ) ) as pricing
-- order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc

-- select func_pricing( '', 'STOGVA61793', date('2015-10-03'), date('2015-10-12'), current date, 1 ) as TOTAL from sysibm.sysdummy1

-- select func_pricingch( '', 'STOGVA61793', '2015-10-03', '2015-10-12', '', 1, '', '' ) as TOTAL from sysibm.sysdummy1



drop function func_hotelpriceav @

--   db2 "SELECT * FROM TABLE (func_hotelpriceav('TSOL', 'BKK', '2017-05-22', '2017-05-29', 2, '', '', '', '', '', '', '', 0, 0, 0, '', '', '')) AS x"
--   
--   db2 "SELECT * FROM TABLE (func_hotelpriceav('TSOL', 'BKK', '2017-05-22', '2017-05-29', 2, 'ANASIA', 'DDV', 'BB', '', '', '', '', 0, 0, 0, '', '', '')) AS x"
--   
--   db2 "SELECT * FROM TABLE (func_hotelpriceav('TSOL', 'BKK', '2017-05-22', '2017-05-29', 2, '', '', '', '', '', '', '', 0, 0, 0, '', 'TOUWAL37281', '')) AS x"

CREATE FUNCTION func_hotelpriceav (
  IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN_DESTINATIONCODE VARCHAR(5) DEFAULT ''
  ,IN_PRICEDATEFROM VARCHAR(10)
  ,IN_PRICEDATETO VARCHAR(10)
  ,IN_NORMALOCCUPANCY INTEGER DEFAULT 2
  ,IN_HOTELCODE VARCHAR(30) DEFAULT ''
  ,IN_ROOMCODE VARCHAR(20) DEFAULT ''
  ,IN_TOURBOMEALCODE VARCHAR(5) DEFAULT ''
  ,IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN_ROOMKEY VARCHAR(20) DEFAULT ''
  ,IN_HOTELKEY VARCHAR(20) DEFAULT ''
  ,IN_CURRENCY VARCHAR(3) DEFAULT 'CHF'
  ,IN_EXPORT_ONLY INTEGER DEFAULT 1
  ,IN_COUNTRYCODE VARCHAR(2) DEFAULT ''
  )
RETURNS TABLE (
  TOCODE VARCHAR(5)
  ,ROOMKEY VARCHAR(20)
  ,TOTAL FLOAT
  ,STATUS VARCHAR(2)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE pricedatefrom DATE;
  DECLARE pricedateto DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;
  DECLARE currentdate DATE;

  SET pricedatefrom = cast(nullif(IN_PRICEDATEFROM, '') AS DATE);
  SET pricedateto = cast(nullif(IN_PRICEDATETO, '') AS DATE);
  SET childbirthdate1 = cast(nullif(IN_CHDDOB1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(IN_CHDDOB2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(IN_CHDDOB3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(IN_CHDDOB4, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(IN_CURRENTDATE, '') AS DATE), CURRENT DATE);

  RETURN
  -- #######################################################################
  -- # Returns sum of price for specific hotel item
  --
  --   Parameters for "func_pricing":
  --    p_tocode VARCHAR(5) DEFAULT ''
  --   ,p_itemkey VARCHAR(20) DEFAULT ''
  --   ,p_startdate DATE DEFAULT NULL -- start of booking period
  --   ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  --   ,p_currentdate DATE DEFAULT CURRENT DATE
  --   ,p_nradults INTEGER DEFAULT 0
  --   ,p_childbirthdate1 DATE DEFAULT NULL
  --   ,p_childbirthdate2 DATE DEFAULT NULL
  --   ,p_childbirthdate3 DATE DEFAULT NULL
  --   ,p_childbirthdate4 DATE DEFAULT NULL
  --     
  --   Parameters for func_get_allotment2:
  --    p_tocode VARCHAR(5) DEFAULT ''
  --   ,p_itemkey VARCHAR(20) DEFAULT ''
  --   ,p_itemtype VARCHAR(1) DEFAULT ''
  --   ,p_startdate DATE DEFAULT NULL
  --   ,p_returndate DATE DEFAULT NULL
  --   ,p_currentdate DATE DEFAULT CURRENT DATE
  -- #######################################################################
  WITH tmptble(XHOTELKEY, XROOMKEY, XPRICE, XALLTOMENTCODE) AS (
      (
        SELECT h.HOTELKEY
          ,r.ROOMKEY
          ,cast(func_pricing(IN_TOCODE, r.ROOMKEY, pricedatefrom, pricedateto, currentdate, IN_NORMALOCCUPANCY, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, IN_CURRENCY) AS FLOAT) AS price
          ,func_get_allotment2(IN_TOCODE, r.ROOMKEY, 'H', pricedatefrom, pricedateto, currentdate) AS STATUS
        FROM TOOHOTEL h
        INNER JOIN TOOROOMS r ON h.HOTELKEY = r.HOTELKEY
          AND h.TOCODE = r.TOCODE
        WHERE h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
          AND h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
          AND r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
          AND r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
          AND r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
          AND r.EXPORT = coalesce(nullif(IN_EXPORT_ONLY, 0), r.EXPORT)
          AND h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
          AND r.NORMALOCCUPANCY = coalesce(nullif(IN_NORMALOCCUPANCY, 0), r.NORMALOCCUPANCY)
		  AND h.COUNTRYISOCODE = coalesce(nullif(IN_COUNTRYCODE, ''), h.COUNTRYISOCODE)
          AND r.TOCODE = IN_TOCODE
          AND h.TOCODE = IN_TOCODE
          AND (
            coalesce(r.PASSIVE, 0) = 0
            OR (
              r.PASSIVE = 1
              AND coalesce(r.FROMDATE, CURRENT DATE) > CURRENT DATE
              )
            )
        )
      )

  SELECT r.TOCODE AS TOCODE
    ,r.ROOMKEY AS ROOMKEY
    ,coalesce(XPRICE, 0) AS PRICE
    ,coalesce(XALLTOMENTCODE, 'XX') AS STATUS
  FROM TOOHOTEL h
  INNER JOIN TOOROOMS r ON h.HOTELKEY = r.HOTELKEY
    AND r.TOCODE = h.TOCODE
  LEFT OUTER JOIN tmptble ON h.HOTELKEY = XHOTELKEY
    AND r.ROOMKEY = XROOMKEY
  WHERE h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
    AND h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
    AND r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
    AND r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
    AND r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
    AND r.EXPORT = coalesce(nullif(IN_EXPORT_ONLY, 0), r.EXPORT)
    AND h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
    AND r.TOCODE = IN_TOCODE
    AND h.TOCODE = IN_TOCODE
    AND r.NORMALOCCUPANCY = coalesce(nullif(IN_NORMALOCCUPANCY, 0), r.NORMALOCCUPANCY)
    AND (
      (
        IN_IGNORE_PRICE0 = 1
        AND XPRICE > 0
        )
      OR IN_IGNORE_PRICE0 = 0
      )
    AND coalesce(XALLTOMENTCODE, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_XX = 1
          THEN 'XX'
        ELSE '..'
        END
      )
    AND coalesce(XALLTOMENTCODE, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_RQ = 1
          THEN 'RQ'
        ELSE '..'
        END
      );
END
@


drop function func_pricing_tbl2 @

CREATE FUNCTION func_pricing_tbl2 (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
  TOCODE VARCHAR(5)
  ,ROOMKEY VARCHAR(20)
  ,NR INTEGER
  ,PRICE DECIMAL(10, 2)
  ,TOTAL DECIMAL(10, 2)
  ,TYPE1 VARCHAR(20) -- PDP, APDP, OT, SO, EB
  ,TYPE2 VARCHAR(20) -- ADT, CHD1, CHD2, CHD3, CHD4
  ,FROMDATE DATE
  ,TODATE DATE
  ,DESCID INTEGER
  ,P_SEQ VARCHAR(20)
  ,PRICETYPE VARCHAR(10)
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

  SELECT p_tocode
    ,p_itemkey
    ,nr
    ,price
    ,total
    ,type1
    ,type2
    ,fromdate
    ,todate
    ,descid
    ,p_seq
    ,pricetype
  FROM TABLE (func_roomvalid(p_tocode, p_itemkey, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
    ,TABLE (func_pricing2_tbl(p_tocode, p_itemkey, 'H', p_startdate, p_returndate, p_currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency)) AS pricing
  WHERE func_test_price(p_tocode, p_itemkey, 'H', p_startdate, p_returndate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency) = 'OK';
END
@



drop function func_hotelpriceav_tbl @

--   SELECT r.TOCODE AS TOCODE
--     ,r.ROOMKEY AS ROOMKEY
--     ,x.NR AS NR
--     ,x.PRICE AS PRICE
--     ,x.TOTAL AS TOTAL
--     ,x.TYPE1 AS TYPE1
--     ,x.TYPE2 AS TYPE2
--     ,x.FROMDATE AS FROMDATE
--     ,x.TODATE AS TODATE
--     ,x.DESCID AS DESCID
--     ,x.P_SEQ AS P_SEQ
--     ,DESCDE
--     ,DESCEN
--     ,DESCFR
--     ,DESCIT
--     ,coalesce(x.STATUS, 'XX') AS STATUS
--   FROM TABLE (func_hotelpriceav_tbl('', 'BKK', '2017-05-05', '2017-05-10', 2, '', '', '', '', '', '', '', 1, 0, 1, '', '', '')) AS x
--   INNER JOIN TOOROOMs r ON r.ROOMKEY = x.ROOMKEY
--   INNER JOIN TOOHOTEL h ON h.HOTELKEY = r.HOTELKEY
--   LEFT OUTER JOIN TOODESCRIPTIONS ON TOODESCRIPTIONS.ITEMKEY = x.ROOMKEY
--     AND ITEMTYPE = 'H'
--     AND TOODESCRIPTIONS.TOCODE = ''
--     AND TOODESCRIPTIONS.DESCID = x.DESCID
--   ORDER BY x.TOCODE
--     ,x.ROOMKEY
--     ,(
--       CASE x.TYPE1
--         WHEN 'PP'
--           THEN 1
--         WHEN 'APP'
--           THEN 2
--         WHEN 'PDP'
--           THEN 3
--         WHEN 'APDP'
--           THEN 4
--         WHEN 'OT'
--           THEN 5
--         WHEN 'SO'
--           THEN 6
--         WHEN 'EB'
--           THEN 7
--         ELSE 8
--         END
--       ) ASC
--     ,x.TYPE2 ASC
--     ,x.FROMDATE ASC


CREATE FUNCTION func_hotelpriceav_tbl (
  IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN_DESTINATIONCODE VARCHAR(5) DEFAULT ''
  ,IN_PRICEDATEFROM VARCHAR(10)
  ,IN_PRICEDATETO VARCHAR(10)
  ,IN_NORMALOCCUPANCY INTEGER DEFAULT 2
  ,IN_HOTELCODE VARCHAR(30) DEFAULT ''
  ,IN_ROOMCODE VARCHAR(20) DEFAULT ''
  ,IN_TOURBOMEALCODE VARCHAR(5) DEFAULT ''
  ,IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN_ROOMKEY VARCHAR(20) DEFAULT ''
  ,IN_HOTELKEY VARCHAR(20) DEFAULT ''
  ,IN_CURRENCY VARCHAR(3) DEFAULT 'CHF'
  ,IN_EXPORT_ONLY INTEGER DEFAULT 1
  ,IN_COUNTRYCODE VARCHAR(2) DEFAULT ''
  )
RETURNS TABLE (
  TOCODE VARCHAR(5)
  ,ROOMKEY VARCHAR(20)
  ,NR INTEGER
  ,PRICE DECIMAL(10, 2)
  ,TOTAL DECIMAL(10, 2)
  ,TYPE1 VARCHAR(20)
  ,TYPE2 VARCHAR(20)
  ,FROMDATE DATE
  ,TODATE DATE
  ,DESCID INTEGER
  ,P_SEQ VARCHAR(20)
  ,STATUS VARCHAR(2)
  ,PRICETYPE VARCHAR(10)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE pricedatefrom DATE;
  DECLARE pricedateto DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;
  DECLARE currentdate DATE;

  SET pricedatefrom = cast(nullif(IN_PRICEDATEFROM, '') AS DATE);
  SET pricedateto = cast(nullif(IN_PRICEDATETO, '') AS DATE);
  SET childbirthdate1 = cast(nullif(IN_CHDDOB1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(IN_CHDDOB2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(IN_CHDDOB3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(IN_CHDDOB4, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(IN_CURRENTDATE, '') AS DATE), CURRENT DATE);

  RETURN
  -- #######################################################################
  -- # Returns sum of price for specific hotel item
  --
  --   Parameters for "func_pricing":
  --    p_tocode VARCHAR(5) DEFAULT ''
  --   ,p_itemkey VARCHAR(20) DEFAULT ''
  --   ,p_startdate DATE DEFAULT NULL -- start of booking period
  --   ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  --   ,p_currentdate DATE DEFAULT CURRENT DATE
  --   ,p_nradults INTEGER DEFAULT 0
  --   ,p_childbirthdate1 DATE DEFAULT NULL
  --   ,p_childbirthdate2 DATE DEFAULT NULL
  --   ,p_childbirthdate3 DATE DEFAULT NULL
  --   ,p_childbirthdate4 DATE DEFAULT NULL
  --     
  --   Parameters for func_get_allotment2:
  --    p_tocode VARCHAR(5) DEFAULT ''
  --   ,p_itemkey VARCHAR(20) DEFAULT ''
  --   ,p_itemtype VARCHAR(1) DEFAULT ''
  --   ,p_startdate DATE DEFAULT NULL
  --   ,p_returndate DATE DEFAULT NULL
  --   ,p_currentdate DATE DEFAULT CURRENT DATE
  -- #######################################################################
  WITH tmptble(XHOTELKEY, XROOMKEY, XPRICE, XALLTOMENTCODE) AS (
      (
        SELECT h.HOTELKEY
          ,r.ROOMKEY
          ,cast(func_pricing(IN_TOCODE, r.ROOMKEY, pricedatefrom, pricedateto, currentdate, IN_NORMALOCCUPANCY, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, IN_CURRENCY) AS FLOAT) AS price
          ,func_get_allotment2(IN_TOCODE, r.ROOMKEY, 'H', pricedatefrom, pricedateto, currentdate) AS STATUS
        FROM TOOHOTEL h
        INNER JOIN TOOROOMS r ON h.HOTELKEY = r.HOTELKEY
          AND h.TOCODE = r.TOCODE
        WHERE h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
          AND h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
          AND r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
          AND r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
          AND r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
          AND r.EXPORT = coalesce(nullif(IN_EXPORT_ONLY, 0), r.EXPORT)
          AND h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
          AND r.NORMALOCCUPANCY = coalesce(nullif(IN_NORMALOCCUPANCY, 0), r.NORMALOCCUPANCY)
		  AND h.COUNTRYISOCODE = coalesce(nullif(IN_COUNTRYCODE, ''), h.COUNTRYISOCODE)
          AND r.TOCODE = IN_TOCODE
          AND h.TOCODE = IN_TOCODE
          AND (
            coalesce(r.PASSIVE, 0) = 0
            OR (
              r.PASSIVE = 1
              AND coalesce(r.FROMDATE, CURRENT DATE) > CURRENT DATE
              )
            )
        )
      )
    ,tmptble1(XHOTELKEY, XROOMKEY, XALLTOMENTCODE, NR, PRICE, TOTAL, TYPE1, TYPE2, FROMDATE, TODATE, DESCID, P_SEQ, PRICETYPE) AS (
      (
        SELECT h.HOTELKEY
          ,r.ROOMKEY
          ,func_get_allotment2(IN_TOCODE, r.ROOMKEY, 'H', pricedatefrom, pricedateto, currentdate) AS STATUS
          ,pricing.NR AS NR
          ,pricing.PRICE AS PRICE
          ,pricing.TOTAL AS TOTAL
          ,pricing.TYPE1 AS TYPE1
          ,pricing.TYPE2 AS TYPE2
          ,pricing.FROMDATE AS FROMDATE
          ,pricing.TODATE AS TODATE
          ,pricing.DESCID AS DESCID
          ,pricing.P_SEQ AS P_SEQ
          ,pricing.PRICETYPE AS PRICETYPE
        FROM TOOHOTEL h
        INNER JOIN TOOROOMS r ON h.HOTELKEY = r.HOTELKEY
          AND h.TOCODE = r.TOCODE
        INNER JOIN TABLE (func_pricing_tbl2(IN_TOCODE, r.ROOMKEY, pricedatefrom, pricedateto, currentdate, IN_NORMALOCCUPANCY, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, IN_CURRENCY)) AS pricing ON pricing.TOCODE = r.TOCODE
          AND pricing.ROOMKEY = r.ROOMKEY
        WHERE h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
          AND h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
          AND r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
          AND r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
          AND r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
          AND r.EXPORT = coalesce(nullif(IN_EXPORT_ONLY, 0), r.EXPORT)
          AND h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
          AND r.NORMALOCCUPANCY = coalesce(nullif(IN_NORMALOCCUPANCY, 0), r.NORMALOCCUPANCY)
		  AND h.COUNTRYISOCODE = coalesce(nullif(IN_COUNTRYCODE, ''), h.COUNTRYISOCODE)
          AND r.TOCODE = IN_TOCODE
          AND h.TOCODE = IN_TOCODE
          AND (
            coalesce(r.PASSIVE, 0) = 0
            OR (
              r.PASSIVE = 1
              AND coalesce(r.FROMDATE, CURRENT DATE) > CURRENT DATE
              )
            )
        )
      )

  SELECT r.TOCODE AS TOCODE
    ,r.ROOMKEY AS ROOMKEY
    ,pricing2.NR AS NR
    ,pricing2.PRICE AS PRICE
    ,pricing2.TOTAL AS TOTAL
    ,pricing2.TYPE1 AS TYPE1
    ,pricing2.TYPE2 AS TYPE2
    ,pricing2.FROMDATE AS FROMDATE
    ,pricing2.TODATE AS TODATE
    ,pricing2.DESCID AS DESCID
    ,pricing2.P_SEQ AS P_SEQ
    ,coalesce(pricing.XALLTOMENTCODE, 'XX') AS STATUS
    ,pricing2.PRICETYPE AS PRICETYPE
  FROM TOOHOTEL h
  INNER JOIN TOOROOMS r ON h.HOTELKEY = r.HOTELKEY
    AND h.TOCODE = r.TOCODE
  LEFT OUTER JOIN tmptble pricing ON h.HOTELKEY = pricing.XHOTELKEY
    AND r.ROOMKEY = pricing.XROOMKEY
  LEFT OUTER JOIN tmptble1 pricing2 ON h.HOTELKEY = pricing2.XHOTELKEY
    AND r.ROOMKEY = pricing2.XROOMKEY
  WHERE h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
    AND h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
    AND r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
    AND r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
    AND r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
    AND r.EXPORT = coalesce(nullif(IN_EXPORT_ONLY, 0), r.EXPORT)
    AND h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
	AND h.COUNTRYISOCODE = coalesce(nullif(IN_COUNTRYCODE, ''), h.COUNTRYISOCODE)
    AND r.TOCODE = IN_TOCODE
    AND h.TOCODE = IN_TOCODE
    AND r.NORMALOCCUPANCY = coalesce(nullif(IN_NORMALOCCUPANCY, 0), r.NORMALOCCUPANCY)
    AND (
      (
        IN_IGNORE_PRICE0 = 1
        AND pricing.XPRICE > 0
        )
      OR IN_IGNORE_PRICE0 = 0
      )
    AND coalesce(pricing.XALLTOMENTCODE, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_XX = 1
          THEN 'XX'
        ELSE '..'
        END
      )
    AND coalesce(pricing.XALLTOMENTCODE, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_RQ = 1
          THEN 'RQ'
        ELSE '..'
        END
      )
  ORDER BY r.TOCODE
    ,r.ROOMKEY
    ,(
      CASE pricing2.TYPE1
        WHEN 'PP'
          THEN 1
        WHEN 'APP'
          THEN 2
        WHEN 'PDP'
          THEN 3
        WHEN 'APDP'
          THEN 4
        WHEN 'OT'
          THEN 5
        WHEN 'SO'
          THEN 6
        WHEN 'EB'
          THEN 7
        WHEN 'EBPCT0'
          THEN 8
        ELSE 9
        END
      ) ASC
    ,pricing2.TYPE2 ASC
    ,pricing2.FROMDATE ASC;
END
@


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

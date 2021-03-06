-- -----------------------------------------------------------------------------
-- Function name: *func_flightpricing_tbl*

-- This function takes into account the minpersons, maxpersons. 
-- Note: this function is only useful for a flight pricing!
-- -----------------------------------------------------------------------------

drop function func_flightpricing_tbl @

CREATE FUNCTION func_flightpricing_tbl (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
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

  RETURN

  SELECT NR
    ,price
    ,total
    ,type1
    ,type2
    ,fromdate
    ,todate
    ,descid
    ,p_seq
    ,pricetype
  FROM
    TABLE (func_flightvalid(p_tocode, p_itemkey, p_startdate, 1, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
    ,TABLE (func_all_flight_tbl(p_tocode, p_itemkey, p_startdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency)) as pricing
  WHERE
    coalesce(p_itemkey,'') <> ''
    AND p_startdate is not null
    and func_test_price_flight(p_tocode, p_itemkey, p_startdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4, p_currency) = 'OK'
  ;
END
@

--
-- select
--    *
--  from
--    TABLE( func_flightpricing_tbl( '', 'BICZRH10337', date('2018-04-10'), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) ) as pricing
-- order by
--   (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc
--   ,TYPE2 asc
--   ,FROMDATE asc
--
-- NR  PRICE    TOTAL    TYPE1  TYPE2  FROMDATE    TODATE     DESCID  P_SEQ
-- --  -------  -------  -----  -----  ----------  ---------- ------  -------
--  1   149.00     149.00     PDP    ADT   2015-11-12   2015-11-12       1  9684803
--


drop function func_flightpricing_tblch @

CREATE FUNCTION func_flightpricing_tblch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
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
  DECLARE currentdate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate, '') AS DATE);
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
  FROM
    TABLE (func_flightpricing_tbl(p_tocode, p_itemkey, cast(nullif(p_startdate, '') AS DATE), currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency)) AS x
  ;
END
@

--
-- select
--    *
--  from
--    TABLE( func_flightpricing_tblch( '', 'TOUWAL18008', '2015-11-12', '', 1, '', '', '', '' ) ) as pricing
-- order by
--   (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc
--   ,TYPE2 asc
--   ,FROMDATE asc
--
-- The following also works correctly passing cast(NULL as char(1)) as a parameter:
-- select
--   *
-- from
--   TABLE( func_flightpricing_tblch( '', 'TUIXYA192344', '2016-10-03', cast(NULL as char(1)), 2, '', '' ) ) as pricing
--
--  NR  PRICE    TOTAL    TYPE1  TYPE2  FROMDATE    TODATE
--  --  -------  -------  -----  -----  ----------  ----------
--   2  348.00  696.00 PDP   ADULT 2016-10-03 2016-10-03



drop function func_flightpricing @

CREATE FUNCTION func_flightpricing (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
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

  DECLARE total DECIMAL(10, 2);
  
  IF p_itemkey='' or p_itemkey is NULL or p_startdate is NULL
    THEN SET total = 0.00;
  ELSE
    SET total = (
      SELECT coalesce(sum(x.TOTAL), 0)
      FROM
          TABLE (func_flightpricing_tbl(p_tocode, p_itemkey, p_startdate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
    );
  END IF; 

  RETURN total;
END
@

--
-- select
--   func_flightpricing(  '', 'TOUWAL18008', date('2015-11-12'), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) as TOTAL
-- from
--    sysibm.sysdummy1
--
--  TOTAL
--  -------
--  149.00
--


drop function func_flightpricingch @

CREATE FUNCTION func_flightpricingch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
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
  FROM TABLE (func_flightpricing_tbl(p_tocode, p_itemkey, cast(nullif(p_startdate, '') AS DATE), currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency)) AS x;
END
@

--
-- select
--   func_flightpricingch(  '', 'TOUWAL18008', '2015-11-12', '2015-11-12', '', 1, '', '', '', '' ) as TOTAL
-- from
--    sysibm.sysdummy1
--
--
--  TOTAL
--  -------
--  5011.20
--


-- select * from TABLE( func_flightpricing_tbl( '', 'STOGVA61793', date('2015-10-03'), date('2015-10-12'), current date, 1 ) ) as pricing
-- order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc

-- select * from TABLE( func_flightpricing_tblch( '', 'STOGVA61793', '2015-10-03', '', 1 ) ) as pricing
-- order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc

-- select func_flightpricing( '', 'STOGVA61793', date('2015-10-03'), current date, 1 ) as TOTAL from sysibm.sysdummy1

-- select func_flightpricingch( '', 'STOGVA61793', '2015-10-03', '', 1, '', '' ) as TOTAL from sysibm.sysdummy1


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

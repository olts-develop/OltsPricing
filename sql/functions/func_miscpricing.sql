-- -----------------------------------------------------------------------------
-- Function name: *func_miscpricing_tbl*

-- This function takes into account the mixpersons, maxpersons. 
-- Note: this function is only useful for a miscellaneous pricing!
-- -----------------------------------------------------------------------------

DROP FUNCTION func_miscpricing_tbl @

CREATE FUNCTION func_miscpricing_tbl (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_itemkey VARCHAR(20) DEFAULT ''
	,p_startdate DATE DEFAULT NULL
	,p_returndate DATE DEFAULT NULL
	,p_currentdate DATE DEFAULT CURRENT DATE
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 DATE DEFAULT NULL
	,p_childbirthdate2 DATE DEFAULT NULL
	,p_childbirthdate3 DATE DEFAULT NULL
	,p_childbirthdate4 DATE DEFAULT NULL
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
	FROM TABLE (func_miscvalid(p_tocode, p_itemkey, p_startdate, p_returndate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x
		,TABLE (func_pricing2_tbl(p_tocode, p_itemkey, 'M', p_startdate, x.PRICEENDDATE, p_currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4)) AS pricing
	WHERE func_test_price(p_tocode, p_itemkey, 'M', p_startdate, x.PRICEENDDATE, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4) = 'OK';
END
 @

--
-- select
--    *
--  from
--    TABLE( func_miscpricing_tbl( '', 'TOUWAL18008', date('2015-11-12'), date('2015-11-12'), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) ) as pricing
-- order by
--   (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc
--   ,TYPE2 asc
--   ,FROMDATE asc
--
-- NR  PRICE    TOTAL    TYPE1  TYPE2  FROMDATE    TODATE     DESCID  P_SEQ
-- --  -------  -------  -----  -----  ----------  ---------- ------  -------
--  1	 149.00	   149.00	   PDP	  ADT	 2015-11-12	 2015-11-12	     1	9684803
--


DROP FUNCTION func_miscpricing_tblch @

CREATE FUNCTION func_miscpricing_tblch (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_itemkey VARCHAR(20) DEFAULT ''
	,p_startdate VARCHAR(10) DEFAULT ''
	,p_returndate VARCHAR(10) DEFAULT ''
	,p_currentdate VARCHAR(10) DEFAULT ''
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 VARCHAR(10) DEFAULT ''
	,p_childbirthdate2 VARCHAR(10) DEFAULT ''
	,p_childbirthdate3 VARCHAR(10) DEFAULT ''
	,p_childbirthdate4 VARCHAR(10) DEFAULT ''
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
	FROM TABLE (func_miscvalid(p_tocode, p_itemkey, startdate, returndate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4)) AS x
		,TABLE (func_pricing2_tbl(p_tocode, p_itemkey, 'M', startdate, x.PRICEENDDATE, currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4)) AS pricing
	WHERE func_test_price(p_tocode, p_itemkey, 'M', startdate, x.PRICEENDDATE, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4) = 'OK';
END
@

--
-- select
--    *
--  from
--    TABLE( func_miscpricing_tblch( '', 'TOUWAL18008', '2015-11-12', '2015-11-12', '', 1, '', '', '', '' ) ) as pricing
-- order by
--   (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc
--   ,TYPE2 asc
--   ,FROMDATE asc
--
-- The following also works correctly passing cast(NULL as char(1)) as a parameter:
-- select
--   *
-- from
--   TABLE( func_miscpricing_tblch( '', 'TUIXYA192344', '2016-10-03', '2016-10-12', cast(NULL as char(1)), 2, '', '' ) ) as pricing
--
--  NR  PRICE    TOTAL    TYPE1  TYPE2  FROMDATE    TODATE
--  --  -------  -------  -----  -----  ----------  ----------
--   2  348.00  696.00 PDP   ADULT 2016-10-03 2016-10-03



DROP FUNCTION func_miscpricing @

CREATE FUNCTION func_miscpricing (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_itemkey VARCHAR(20) DEFAULT ''
	,p_startdate DATE DEFAULT NULL
	,p_returndate DATE DEFAULT NULL
	,p_currentdate DATE DEFAULT CURRENT DATE
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 DATE DEFAULT NULL
	,p_childbirthdate2 DATE DEFAULT NULL
	,p_childbirthdate3 DATE DEFAULT NULL
	,p_childbirthdate4 DATE DEFAULT NULL
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
	FROM TABLE (func_miscpricing_tbl(p_tocode, p_itemkey, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x;
END
@

--
-- select
--   func_miscpricing(  '', 'TOUWAL18008', date('2015-11-12'), date('2015-11-12'), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) as TOTAL
-- from
--    sysibm.sysdummy1
--
--  TOTAL
--  -------
--  149.00
--


DROP FUNCTION func_miscpricingch @

CREATE FUNCTION func_miscpricingch (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_itemkey VARCHAR(20) DEFAULT ''
	,p_startdate VARCHAR(10) DEFAULT ''
	,p_returndate VARCHAR(10) DEFAULT ''
	,p_currentdate VARCHAR(10) DEFAULT ''
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 VARCHAR(10) DEFAULT ''
	,p_childbirthdate2 VARCHAR(10) DEFAULT ''
	,p_childbirthdate3 VARCHAR(10) DEFAULT ''
	,p_childbirthdate4 VARCHAR(10) DEFAULT ''
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
	FROM TABLE (func_miscpricing_tbl(p_tocode, p_itemkey, cast(nullif(p_startdate, '') AS DATE), cast(nullif(p_returndate, '') AS DATE), currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4)) AS x;
END
@




--
-- select
--   func_miscpricingch(  '', 'TOUWAL18008', '2015-11-12', '2015-11-12', '', 1, '', '', '', '' ) as TOTAL
-- from
--    sysibm.sysdummy1
--
--
--  TOTAL
--  -------
--  5011.20
--


-- select * from TABLE( func_miscpricing_tbl( '', 'STOGVA61793', date('2015-10-03'), date('2015-10-12'), current date, 1 ) ) as pricing
-- order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc

-- select * from TABLE( func_miscpricing_tblch( '', 'STOGVA61793', '2015-10-03', '2015-10-12', '', 1 ) ) as pricing
-- order by (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc, TYPE2 asc, FROMDATE asc

-- select func_miscpricing( '', 'STOGVA61793', date('2015-10-03'), date('2015-10-12'), current date, 1 ) as TOTAL from sysibm.sysdummy1

-- select func_miscpricingch( '', 'STOGVA61793', '2015-10-03', '2015-10-12', '', 1, '', '' ) as TOTAL from sysibm.sysdummy1


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

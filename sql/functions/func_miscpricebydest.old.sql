-- -----------------------------------------------------------------------------
-- Pricing and Availability
-- -----------------------------------------------------------------------------

DROP FUNCTION func_miscpricebydest @

-- select * from TABLE( func_miscpricebydest ('', 'AGR', cast('2015-11-12' as DATE), cast('2015-11-12' as DATE), current date, 1 ) )
CREATE FUNCTION func_miscpricebydest (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_destcode VARCHAR(20) DEFAULT '???'
	,p_startdate DATE DEFAULT NULL
	,p_enddate DATE DEFAULT NULL
	,p_currentdate DATE DEFAULT CURRENT DATE
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 DATE DEFAULT NULL
	,p_childbirthdate2 DATE DEFAULT NULL
	,p_childbirthdate3 DATE DEFAULT NULL
	,p_childbirthdate4 DATE DEFAULT NULL
	)
RETURNS TABLE (
	TOCODE VARCHAR(20)
	,MISCKEY VARCHAR(20)
	,TOTAL DECIMAL(10, 2)
	,DESTINATIONCODE VARCHAR(5)
	,MISCCODE VARCHAR(30)
	,TOURBOCODE VARCHAR(20)
	,STATUS VARCHAR(4)
	)

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
	ATOMIC

	RETURN

	SELECT p_tocode
		,toomisc.misckey
		,func_miscpricing(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4) AS pricetotal
		,destinationcode
		,misccode
		,miscitemcode
		,func_get_allotment2(p_tocode, toomisc.misckey, 'M', p_startdate, x.ALLOTMENTENDDATE, p_currentdate )
	FROM toomisc
		, TABLE (func_miscvalid(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x
	WHERE toomisc.tocode = p_tocode
		AND toomisc.destinationcode = p_destcode
;
END
@

DROP FUNCTION func_miscpricebydest_ch @

-- select * from TABLE( func_miscpricebydest_ch ('', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
-- select * from TABLE( func_miscpricebydest_ch ('TOU', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_miscpricebydest_ch (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_destcode VARCHAR(20) DEFAULT '???'
	,p_startdate VARCHAR(10) DEFAULT ''
	,p_enddate VARCHAR(10) DEFAULT ''
	,p_currentdate VARCHAR(10) DEFAULT ''
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 VARCHAR(10) DEFAULT ''
	,p_childbirthdate2 VARCHAR(10) DEFAULT ''
	,p_childbirthdate3 VARCHAR(10) DEFAULT ''
	,p_childbirthdate4 VARCHAR(10) DEFAULT ''
	)
RETURNS TABLE (
	TOCODE VARCHAR(20)
	,MISCKEY VARCHAR(20)
	,TOTAL DECIMAL(10, 2)
	,DESTINATIONCODE VARCHAR(5)
	,MISCCODE VARCHAR(30)
	,TOURBOCODE VARCHAR(20)
	,STATUS VARCHAR(4)
	)

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
	ATOMIC

	DECLARE startdate DATE;
	DECLARE enddate DATE;
	DECLARE currentdate DATE;
	DECLARE childbirthdate1 DATE;
	DECLARE childbirthdate2 DATE;
	DECLARE childbirthdate3 DATE;
	DECLARE childbirthdate4 DATE;

	SET startdate = cast(nullif(p_startdate, '') AS DATE);
	SET enddate = cast(nullif(p_enddate, '') AS DATE);
	SET currentdate = coalesce(cast(nullif(p_currentdate, '') AS DATE), CURRENT DATE);
	SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
	SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
	SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
	SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);

	RETURN

	SELECT TOCODE
		,MISCKEY
		,TOTAL
		,DESTINATIONCODE
		,MISCCODE
		,TOURBOCODE
		,STATUS
	FROM TABLE ( func_miscpricebydest(p_tocode, p_destcode, startdate, enddate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) )
;
END
@



DROP FUNCTION func_miscpriceav @

-- select * from TABLE( func_miscpriceav ('', cast('2015-11-12' as DATE), cast('2015-11-12' as DATE), current date, 1 ) )
CREATE FUNCTION func_miscpriceav (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_startdate DATE DEFAULT NULL
	,p_enddate DATE DEFAULT NULL
	,p_currentdate DATE DEFAULT CURRENT DATE
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 DATE DEFAULT NULL
	,p_childbirthdate2 DATE DEFAULT NULL
	,p_childbirthdate3 DATE DEFAULT NULL
	,p_childbirthdate4 DATE DEFAULT NULL
	)
RETURNS TABLE (
	TOCODE VARCHAR(20)
	,MISCKEY VARCHAR(20)
	,TOTAL DECIMAL(10, 2)
	,DESTINATIONCODE VARCHAR(5)
	,MISCCODE VARCHAR(30)
	,TOURBOCODE VARCHAR(20)
	,STATUS VARCHAR(4)
	)

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
	ATOMIC

	RETURN

	SELECT p_tocode
		,toomisc.misckey
		,func_miscpricing(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4) AS pricetotal
		,destinationcode
		,misccode
		,miscitemcode
		,func_get_allotment2(p_tocode, toomisc.misckey, 'M', p_startdate, x.ALLOTMENTENDDATE, p_currentdate )
	FROM toomisc
		, TABLE (func_miscvalid(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x
	WHERE toomisc.tocode = p_tocode
;
END
@

DROP FUNCTION func_miscpriceav_ch @

-- select * from TABLE( func_miscpriceav_ch ('', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
-- select * from TABLE( func_miscpriceav_ch ('TSOL', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_miscpriceav_ch (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_startdate VARCHAR(10) DEFAULT ''
	,p_enddate VARCHAR(10) DEFAULT ''
	,p_currentdate VARCHAR(10) DEFAULT ''
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 VARCHAR(10) DEFAULT ''
	,p_childbirthdate2 VARCHAR(10) DEFAULT ''
	,p_childbirthdate3 VARCHAR(10) DEFAULT ''
	,p_childbirthdate4 VARCHAR(10) DEFAULT ''
	)
RETURNS TABLE (
	TOCODE VARCHAR(20)
	,MISCKEY VARCHAR(20)
	,TOTAL DECIMAL(10, 2)
	,DESTINATIONCODE VARCHAR(5)
	,MISCCODE VARCHAR(30)
	,TOURBOCODE VARCHAR(20)
	,STATUS VARCHAR(4)
	)

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
	ATOMIC

	DECLARE startdate DATE;
	DECLARE enddate DATE;
	DECLARE currentdate DATE;
	DECLARE childbirthdate1 DATE;
	DECLARE childbirthdate2 DATE;
	DECLARE childbirthdate3 DATE;
	DECLARE childbirthdate4 DATE;

	SET startdate = cast(nullif(p_startdate, '') AS DATE);
	SET enddate = cast(nullif(p_enddate, '') AS DATE);
	SET currentdate = coalesce(cast(nullif(p_currentdate, '') AS DATE), CURRENT DATE);
	SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
	SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
	SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
	SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);

	RETURN

	SELECT TOCODE
		,MISCKEY
		,TOTAL
		,DESTINATIONCODE
		,MISCCODE
		,TOURBOCODE
		,STATUS
	FROM TABLE ( func_miscpriceav(p_tocode, startdate, enddate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) )
;
END
@



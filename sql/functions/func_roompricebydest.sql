-- -----------------------------------------------------------------------------
-- Pricing
-- -----------------------------------------------------------------------------

DROP FUNCTION func_roompricebydest @

-- select * from TABLE( func_roompricebydest ('STOH', 'MRU', cast('2015-09-01' as DATE), cast('2015-09-25' as DATE),current date, 2 ) )
CREATE FUNCTION func_roompricebydest (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_destcode VARCHAR(20) DEFAULT '???'
	,p_startdate DATE DEFAULT NULL -- start of booking period
	,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
	,p_currentdate DATE DEFAULT CURRENT DATE
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 DATE DEFAULT NULL
	,p_childbirthdate2 DATE DEFAULT NULL
	,p_childbirthdate3 DATE DEFAULT NULL
	,p_childbirthdate4 DATE DEFAULT NULL
	)
RETURNS TABLE (
	TOCODE VARCHAR(20)
	,ROOMKEY VARCHAR(20)
	,TOTAL DECIMAL(10, 2)
	,DESTINATIONCODE VARCHAR(5)
	,HOTELCODE VARCHAR(30)
	,TOURBOCODE VARCHAR(20)
	,MEALCODE VARCHAR(50)
	,STATUS VARCHAR(4)
	)

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
	ATOMIC

	RETURN

	SELECT p_tocode
		,toorooms.roomkey
		,func_pricing(p_tocode, toorooms.roomkey, p_startdate, p_returndate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4) AS pricetotal
		,destinationcode
		,hotelcode
		,tourbocode
		,mealcode
		,func_get_allotment2(p_tocode, toorooms.roomkey, 'H', p_startdate, p_returndate, p_currentdate)
	FROM toorooms
		,toohotel
	WHERE toohotel.hotelkey = toorooms.hotelkey
		AND toohotel.tocode = toorooms.tocode
		AND toorooms.tocode = p_tocode
		AND toohotel.tocode = p_tocode
		AND toohotel.destinationcode = p_destcode
;
END
@

DROP FUNCTION func_roompricebydest_ch @

-- select * from TABLE( func_roompricebydest_ch ('', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_roompricebydest_ch (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_destcode VARCHAR(20) DEFAULT '???'
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
	TOCODE VARCHAR(20)
	,ROOMKEY VARCHAR(20)
	,TOTAL DECIMAL(10, 2)
	,DESTINATIONCODE VARCHAR(5)
	,HOTELCODE VARCHAR(30)
	,TOURBOCODE VARCHAR(20)
	,MEALCODE VARCHAR(50)
	,STATUS VARCHAR(4)
	)

NOT DETERMINISTIC LANGUAGE SQL

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

	SELECT 	TOCODE
	,ROOMKEY
	,TOTAL
	,DESTINATIONCODE
	,HOTELCODE
	,TOURBOCODE
	,MEALCODE
	,STATUS
	FROM TABLE ( func_roompricebydest(p_tocode, p_destcode, startdate, returndate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) )
;
END
@





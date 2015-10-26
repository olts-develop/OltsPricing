-- -----------------------------------------------------------------------------
-- Function name: *func_miscvalid*

-- Returns a either a row with the nr adults and birth dates for the children
-- after taking into account the passed parameters and the occupancy details
-- of the specific misc, or returns an empty table.
-- -----------------------------------------------------------------------------

DROP FUNCTION func_miscvalid @

CREATE FUNCTION func_miscvalid (
	p_tocode VARCHAR(5) DEFAULT ''
	,p_misckey VARCHAR(20) DEFAULT ''
	,p_startdate DATE DEFAULT NULL
	,p_enddate DATE DEFAULT NULL
	,p_nradults INTEGER DEFAULT 0
	,p_childbirthdate1 DATE DEFAULT NULL
	,p_childbirthdate2 DATE DEFAULT NULL
	,p_childbirthdate3 DATE DEFAULT NULL
	,p_childbirthdate4 DATE DEFAULT NULL
	)
RETURNS TABLE (
	NRADULTS INTEGER
	,CHILDBIRTHDATE1 DATE
	,CHILDBIRTHDATE2 DATE
	,CHILDBIRTHDATE3 DATE
	,CHILDBIRTHDATE4 DATE
	-- The misc might be start date relevant only, which affects
	-- the pricing and/or allotment SQL function parameters.
	,PRICEENDDATE DATE
	,ALLOTMENTENDDATE DATE
	) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
	ATOMIC

	DECLARE childage1 DECIMAL(10, 4);
	DECLARE childage2 DECIMAL(10, 4);
	DECLARE childage3 DECIMAL(10, 4);
	DECLARE childage4 DECIMAL(10, 4);
	DECLARE totalpaxnr INTEGER;
	DECLARE enddate DATE;
	DECLARE duration INTEGER;

	SET childage1 = ((DAYS(p_startdate) - DAYS(p_childbirthdate1)) / 365);
	SET childage2 = ((DAYS(p_startdate) - DAYS(p_childbirthdate2)) / 365);
	SET childage3 = ((DAYS(p_startdate) - DAYS(p_childbirthdate3)) / 365);
	SET childage4 = ((DAYS(p_startdate) - DAYS(p_childbirthdate4)) / 365);
	SET totalpaxnr = p_nradults + (
			CASE 
				WHEN p_childbirthdate1 IS NOT NULL
					AND childage1 >= 2.0
					THEN 1
				ELSE 0
				END
			) + (
			CASE 
				WHEN p_childbirthdate2 IS NOT NULL
					AND childage2 >= 2.0
					THEN 1
				ELSE 0
				END
			) + (
			CASE 
				WHEN p_childbirthdate3 IS NOT NULL
					AND childage3 >= 2.0
					THEN 1
				ELSE 0
				END
			) + (
			CASE 
				WHEN p_childbirthdate4 IS NOT NULL
					AND childage4 >= 2.0
					THEN 1
				ELSE 0
				END
			);
	SET enddate = coalesce(p_enddate, p_startdate);
	SET duration = DAYS(p_enddate) - DAYS(p_startdate) + 1;

	RETURN

	SELECT
		p_nradults
		,func_getposdatedesc(0, 1, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
		,func_getposdatedesc(0, 2, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
		,func_getposdatedesc(0, 3, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
		,func_getposdatedesc(0, 4, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
		,(
			CASE
				WHEN minimumdays > 0
					AND DAYS(enddate) - DAYS(p_startdate) < minimumdays -1
					THEN p_startdate + (minimumdays) DAYS
				WHEN minimumdays > 0
					AND DAYS(enddate) - DAYS(p_startdate) > maximumdays -1
					THEN p_startdate + (maximumdays) DAYS
				ELSE enddate + 1 DAY
				END
			) as PRICEENDDATE
		,(
			CASE 
				WHEN startdaterelevant = 1
					THEN p_startdate + 1 DAY
				ELSE enddate + 1 DAY
				END
			) as ALLOTMENTENDDATE
	FROM toomisc
	WHERE misckey = p_misckey
		AND tocode = p_tocode
		AND (
			(
				minimumpersons = 0
				AND maximumpersons = 0
				)
			OR (
				minimumpersons <= totalpaxnr
				AND maximumpersons >= totalpaxnr
				)
			)
		AND p_nradults > 0
		AND minimumdays <= maximumdays;
END
@

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

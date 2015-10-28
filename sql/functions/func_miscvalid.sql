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

DROP FUNCTION func_miscvalid_ch @

create function func_miscvalid_ch
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_misckey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_enddate VARCHAR(10) DEFAULT '' 
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
)
RETURNS
  TABLE
  (
	NRADULTS INTEGER
	,CHILDBIRTHDATE1 DATE
	,CHILDBIRTHDATE2 DATE
	,CHILDBIRTHDATE3 DATE
	,CHILDBIRTHDATE4 DATE
	-- The misc might be start date relevant only, which affects
	-- the pricing and/or allotment SQL function parameters.
	,PRICEENDDATE DATE
	,ALLOTMENTENDDATE DATE
  )
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

  DECLARE startdate DATE;
  DECLARE enddate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate,'') as date) ;
  SET enddate = cast(nullif(p_enddate,'') as date) ;
  SET childbirthdate1 = cast(nullif(p_childbirthdate1,'') as date) ;
  SET childbirthdate2 = cast(nullif(p_childbirthdate2,'') as date) ;
  SET childbirthdate3 = cast(nullif(p_childbirthdate3,'') as date) ;
  SET childbirthdate4 = cast(nullif(p_childbirthdate4,'') as date) ;

RETURN

SELECT
	x.NRADULTS
	,x.CHILDBIRTHDATE1
	,x.CHILDBIRTHDATE2
	,x.CHILDBIRTHDATE3
	,x.CHILDBIRTHDATE4
	,x.PRICEENDDATE
	,x.ALLOTMENTENDDATE
FROM
   TABLE( func_miscvalid( p_tocode, p_misckey, startdate, enddate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4 ) ) AS x
;
END
@

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

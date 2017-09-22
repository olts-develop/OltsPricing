WITH tmp_leg_1 (
		FLIGHTKEY1
		,LEGKEY1
		,DEPTS1
		,ARRTS1
	)
AS (
	SELECT 
		leg1.FLIGHTKEY
		,leg1.LEGKEY
		,cast(timestamp (
				a1.ALLOTDATE
				,a1.DEPTIME
				) as char(26))
		,cast(timestamp (
				a1.ALLOTDATE + a1.ARRTIMEDEV days
				,a1.ARRTIME
				) as char(26))
	FROM
		TOOFLIGHTLEG leg1
		LEFT OUTER JOIN TOOALLOTMENTS a1 on
			a1.ITEMKEY = leg1.LEGKEY
			AND a1.ITEMTYPE = 'F'
			AND a1.ALLOTDATE = '2018-01-02'
	WHERE
		leg1.FLIGHTKEY = 'BICZRH10337'
		AND (
			(
				leg1.FLIGHTKEY = leg1.LEGKEY
				AND leg1.POS = 0
				)
			or leg1.POS = 1
			)
	)
	,tmp_leg_2 (
		LEGKEY2
		,DEPTS2
		,ARRTS2
	)
AS (
	SELECT
		leg2.LEGKEY
		,cast(coalesce(timestamp (
					a2_0.ALLOTDATE
					,a2_0.DEPTIME
					), timestamp (
					a2_1.ALLOTDATE
					,a2_1.DEPTIME
					)) as char(26))
		,cast(coalesce(timestamp (
					a2_0.ALLOTDATE + a2_0.ARRTIMEDEV days
					,a2_0.ARRTIME
					), timestamp (
					a2_1.ALLOTDATE + a2_1.ARRTIMEDEV days
					,a2_1.ARRTIME
					)) as char(26))
	FROM
		TOOFLIGHTLEG leg2
		INNER JOIN TOOFLIGHT on TOOFLIGHT.FLIGHTKEY = leg2.FLIGHTKEY and TOOFLIGHT.MULTILEG=1
		INNER JOIN tmp_leg_1 on 1 = 1
		LEFT OUTER JOIN TOOALLOTMENTS a2_0 on
			a2_0.ITEMKEY = leg2.LEGKEY
			AND a2_0.ITEMTYPE = 'F'
			AND a2_0.ALLOTDATE = date (ARRTS1)
			AND timestamp (
				a2_0.ALLOTDATE
				,a2_0.DEPTIME
				) > ARRTS1
		LEFT OUTER JOIN TOOALLOTMENTS a2_1 on a2_1.ITEMKEY = leg2.LEGKEY
			AND a2_1.ITEMTYPE = 'F'
			AND a2_1.ALLOTDATE = date (ARRTS1) + 1 day
			AND timestamp (
				a2_1.ALLOTDATE
				,a2_1.DEPTIME
				) > ARRTS1
	WHERE
		leg2.FLIGHTKEY = tmp_leg_1.FLIGHTKEY1
		AND leg2.POS = 2
		AND TOOFLIGHT.MULTILEG=1
	)

SELECT
	LEGKEY1
	,DEPTS1
	,ARRTS1
	,LEGKEY2
	,DEPTS2
	,ARRTS2
	,func_get_allotment2('', LEGKEY1, 'F', date (DEPTS1), date (DEPTS1) + 1 day, current date) as allotleg1
	,case when LEGKEY2 is not null then func_get_allotment2('', LEGKEY2, 'F', date (DEPTS2), date (DEPTS2) + 1 day, current date) else '' end as allotleg2
	,func_flightpricing( '', tmp_leg_1.LEGKEY1, date(DEPTS1), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) as priceleg1
	,func_flightpricing( '', tmp_leg_2.LEGKEY2, date(DEPTS2), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) as priceleg2
FROM
	tmp_leg_1
	LEFT OUTER JOIN tmp_leg_2 on
		date(DEPTS2) is not null

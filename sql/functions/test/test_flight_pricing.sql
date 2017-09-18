with tmp_leg_1 (
    FLIGHTKEY1
	,LEGKEY1
	,DEPTS1
	,ARRTS1
	)
as (
	select 
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
	from TOOFLIGHTLEG leg1
	LEFT OUTER JOIN TOOALLOTMENTS a1 on a1.ITEMKEY = leg1.LEGKEY
		and a1.ITEMTYPE = 'F'
		and a1.ALLOTDATE = '2018-02-06'
	where leg1.FLIGHTKEY = 'BICZRH10337'
		and (
			(
				leg1.FLIGHTKEY = leg1.LEGKEY
				and leg1.POS = 0
				)
			or leg1.POS = 1
			)
	)
	,tmp_leg_2 (
	LEGKEY2
	,DEPTS2
	,ARRTS2
	)
as (
	select leg2.LEGKEY
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
	from TOOFLIGHTLEG leg2
	INNER JOIN tmp_leg_1 on 1 = 1
	LEFT OUTER JOIN TOOALLOTMENTS a2_0 on a2_0.ITEMKEY = leg2.LEGKEY
		and a2_0.ITEMTYPE = 'F'
		and a2_0.ALLOTDATE = date (ARRTS1)
		and timestamp (
			a2_0.ALLOTDATE
			,a2_0.DEPTIME
			) > ARRTS1
	LEFT OUTER JOIN TOOALLOTMENTS a2_1 on a2_1.ITEMKEY = leg2.LEGKEY
		and a2_1.ITEMTYPE = 'F'
		and a2_1.ALLOTDATE = date (ARRTS1) + 1 day
		and timestamp (
			a2_1.ALLOTDATE
			,a2_1.DEPTIME
			) > ARRTS1
	where leg2.FLIGHTKEY = tmp_leg_1.FLIGHTKEY1
		and leg2.POS = 2
	)
	,tmp_leg_3 (
	LEGKEY3
	,DEPTS3
	,ARRTS3
	)
as (
	select leg3.LEGKEY
		,cast(coalesce(timestamp (
					a3_0.ALLOTDATE
					,a3_0.DEPTIME
					), timestamp (
					a3_1.ALLOTDATE
					,a3_1.DEPTIME
					)) as char(26))
		,cast(coalesce(timestamp (
					a3_0.ALLOTDATE + a3_0.ARRTIMEDEV days
					,a3_0.ARRTIME
					), timestamp (
					a3_1.ALLOTDATE + a3_1.ARRTIMEDEV days
					,a3_1.ARRTIME
					)) as char(26))
	from TOOFLIGHTLEG leg3
	INNER JOIN tmp_leg_2 on 1 = 1
	INNER JOIN tmp_leg_1 on 1 = 1
	LEFT OUTER JOIN TOOALLOTMENTS a3_0 on a3_0.ITEMKEY = leg3.LEGKEY
		and a3_0.ITEMTYPE = 'F'
		and a3_0.ALLOTDATE = date (ARRTS2)
		and timestamp (
			a3_0.ALLOTDATE
			,a3_0.DEPTIME
			) > ARRTS2
	LEFT OUTER JOIN TOOALLOTMENTS a3_1 on a3_1.ITEMKEY = leg3.LEGKEY
		and a3_1.ITEMTYPE = 'F'
		and a3_1.ALLOTDATE = date (ARRTS2) + 1 day
		and timestamp (
			a3_1.ALLOTDATE
			,a3_1.DEPTIME
			) > ARRTS2
	where leg3.FLIGHTKEY = tmp_leg_1.FLIGHTKEY1
		and leg3.POS = 3
	)
	,tmp_leg_4 (
	LEGKEY4
	,DEPTS4
	,ARRTS4
	)
as (
	select leg4.LEGKEY
		,cast(coalesce(timestamp (
					a4_0.ALLOTDATE
					,a4_0.DEPTIME
					), timestamp (
					a4_1.ALLOTDATE
					,a4_1.DEPTIME
					)) as char(26))
		,cast(coalesce(timestamp (
					a4_0.ALLOTDATE + a4_0.ARRTIMEDEV days
					,a4_0.ARRTIME
					), timestamp (
					a4_1.ALLOTDATE + a4_1.ARRTIMEDEV days
					,a4_1.ARRTIME
					)) as char(26))
	from TOOFLIGHTLEG leg4
	INNER JOIN tmp_leg_3 on 1 = 1
	INNER JOIN tmp_leg_1 on 1 = 1
	LEFT OUTER JOIN TOOALLOTMENTS a4_0 on a4_0.ITEMKEY = leg4.LEGKEY
		and a4_0.ITEMTYPE = 'F'
		and a4_0.ALLOTDATE = date (ARRTS3)
		and timestamp (
			a4_0.ALLOTDATE
			,a4_0.DEPTIME
			) > ARRTS3
	LEFT OUTER JOIN TOOALLOTMENTS a4_1 on a4_1.ITEMKEY = leg4.LEGKEY
		and a4_1.ITEMTYPE = 'F'
		and a4_1.ALLOTDATE = date (ARRTS3) + 1 day
		and timestamp (
			a4_1.ALLOTDATE
			,a4_1.DEPTIME
			) > ARRTS3
	where leg4.FLIGHTKEY = tmp_leg_1.FLIGHTKEY1
		and leg4.POS = 4
	)
select LEGKEY1
	,DEPTS1
	,ARRTS1
	,LEGKEY2
	,DEPTS2
	,ARRTS2
	,LEGKEY3
	,DEPTS3
	,ARRTS3
	,LEGKEY4
	,DEPTS4
	,ARRTS4
	,func_get_allotment2('', LEGKEY1, 'F', date (DEPTS1), date (DEPTS1) + 1 day, current date) as allotleg1
	,case when LEGKEY2 is not null then func_get_allotment2('', LEGKEY2, 'F', date (DEPTS2), date (DEPTS2) + 1 day, current date) else '' end as allotleg2
	,case when LEGKEY3 is not null then func_get_allotment2('', LEGKEY3, 'F', date (DEPTS3), date (DEPTS3) + 1 day, current date) else '' end as allotleg3
	,case when LEGKEY4 is not null then func_get_allotment2('', LEGKEY4, 'F', date (DEPTS4), date (DEPTS4) + 1 day, current date) else '' end as allotleg4
	,func_flightpricing( '', tmp_leg_1.LEGKEY1, date(DEPTS1), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) as priceleg1
	,case when LEGKEY2 is not null then func_flightpricing( '', tmp_leg_2.LEGKEY2, date(DEPTS2), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) else 0.00 end as priceleg2
	,case when LEGKEY3 is not null then func_flightpricing( '', tmp_leg_3.LEGKEY3, date(DEPTS3), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) else 0.00 end as priceleg3
	,case when LEGKEY4 is not null then func_flightpricing( '', tmp_leg_4.LEGKEY4, date(DEPTS4), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) else 0.00 end as priceleg4
	
from tmp_leg_1
LEFT OUTER JOIN tmp_leg_2 on 1 = 1
LEFT OUTER JOIN tmp_leg_3 on 1 = 1
LEFT OUTER JOIN tmp_leg_4 on 1 = 1

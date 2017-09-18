select
    *
  from
    TABLE( func_flightpricing_tbl( '', 'BICZRH10337', date('2018-02-11'), current date, 1, cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE), cast(NULL as DATE) ) ) as pricing
 order by
   (case TYPE1 when 'PP' then 1 when 'APP' then 2 when 'PDP' then 3 when 'APDP' then 4 when 'OT' then 5 when 'SO' then 6 when 'EB' then 7 else 8 end) asc
   ,TYPE2 asc
   ,FROMDATE asc
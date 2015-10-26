-- -----------------------------------------------------------------------------
-- Function name: *func_pricing_tbl*

-- This function takes into account the occuancy in a room and assings children
-- as adults should this be necessary. In a double room with one adult and one
-- child the child will be treated as an adult via the "func_roomvalid"
-- function.
-- -----------------------------------------------------------------------------

drop function func_pricingmisc_tbl @

create function func_pricingmisc_tbl
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_misckey VARCHAR(20) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
)
RETURNS
  TABLE
  (
     NR INTEGER
    ,PRICE DECIMAL(10,2)
    ,TOTAL DECIMAL(10,2)
    ,TYPE1 VARCHAR(20) -- PDP, APDP, OT, SO, EB
    ,TYPE2 VARCHAR(20) -- ADT, CHD1, CHD2, CHD3, CHD4
    ,FROMDATE DATE
    ,TODATE DATE
    ,DESCID INTEGER
    ,P_SEQ VARCHAR(20)
  )
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

--  DECLARE childbirthdate1 DATE;
--  DECLARE childbirthdate2 DATE;
--  DECLARE childbirthdate3 DATE;
--  DECLARE childbirthdate4 DATE;

--  SET childbirthdate1 = p_childbirthdate1 ;
--  SET childbirthdate2 = p_childbirthdate2 ;
--  SET childbirthdate3 = p_childbirthdate3 ;
--  SET childbirthdate4 = p_childbirthdate4 ;

RETURN

SELECT
   nr
  ,price
  ,total
  ,type1
  ,type2
  ,fromdate
  ,todate
  ,descid
  ,p_seq
FROM
   TABLE( func_miscvalid( p_tocode, p_misckey, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4 ) ) AS x
  ,TABLE( func_pricing2_tbl( p_tocode, p_misckey, 'M', p_startdate, p_returndate, p_currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) ) as pricing
WHERE
  func_test_price( p_tocode, p_misckey, p_startdate, p_returndate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) = 'OK'
;

END @

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


drop function func_pricingmisc_tblch @

create function func_pricingmisc_tblch
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_misckey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_returndate VARCHAR(10) DEFAULT '' -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
)
RETURNS
  TABLE
  (
     NR INTEGER
    ,PRICE DECIMAL(10,2)
    ,TOTAL DECIMAL(10,2)
    ,TYPE1 VARCHAR(20) -- PDP, APDP, OT, SO, EB
    ,TYPE2 VARCHAR(20) -- ADULT, CHD1, CHD2
    ,FROMDATE DATE
    ,TODATE DATE
    ,DESCID INTEGER
    ,P_SEQ VARCHAR(20)
  )
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

  DECLARE startdate DATE;
  DECLARE returndate DATE;
  DECLARE currentdate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate,'') as date) ;
  SET returndate = cast(nullif(p_returndate,'') as date) ;
  SET currentdate = cast(nullif(p_currentdate,'') as date) ;
  SET childbirthdate1 = cast(nullif(p_childbirthdate1,'') as date) ;
  SET childbirthdate2 = cast(nullif(p_childbirthdate2,'') as date) ;
  SET childbirthdate3 = cast(nullif(p_childbirthdate3,'') as date) ;
  SET childbirthdate4 = cast(nullif(p_childbirthdate4,'') as date) ;

RETURN

SELECT
   nr
  ,price
  ,total
  ,type1
  ,type2
  ,fromdate
  ,todate
  ,descid
  ,p_seq
FROM
   TABLE( func_miscvalid( p_tocode, p_misckey, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4 ) ) AS x
  ,TABLE( func_pricing2_tbl( p_tocode, p_misckey, 'M', startdate, returndate, currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) ) as pricing

;

END @

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


drop function func_pricingmisc @

create function func_pricingmisc
(
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_misckey VARCHAR(20) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL -- start of booking period
  ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
)
RETURNS
  DECIMAL (10,2)
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

--  DECLARE childbirthdate1 DATE;
--  DECLARE childbirthdate2 DATE;
--  DECLARE childbirthdate3 DATE;
--  DECLARE childbirthdate4 DATE;

--  SET childbirthdate1 = p_childbirthdate1 ;
--  SET childbirthdate2 = p_childbirthdate2 ;
--  SET childbirthdate3 = p_childbirthdate3 ;
--  SET childbirthdate4 = p_childbirthdate4 ;

RETURN

select
  coalesce(sum(x.TOTAL),0)
from
TABLE(
  func_pricingmisc_tbl
  (
    p_tocode
    ,p_misckey
    ,p_startdate
    ,p_returndate
    ,p_currentdate
    ,p_nradults
    ,p_childbirthdate1
    ,p_childbirthdate2
    ,p_childbirthdate3
    ,p_childbirthdate4
  )
) as x

;
END @

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


drop function func_pricingmiscch @

create function func_pricingmiscch
(
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_misckey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT '' -- start of booking period
  ,p_returndate VARCHAR(10) DEFAULT '' -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
)
RETURNS
  DECIMAL (10,2)
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET childbirthdate1 = cast(nullif(p_childbirthdate1,'') as date) ;
  SET childbirthdate2 = cast(nullif(p_childbirthdate2,'') as date) ;
  SET childbirthdate3 = cast(nullif(p_childbirthdate3,'') as date) ;
  SET childbirthdate4 = cast(nullif(p_childbirthdate4,'') as date) ;
--  SET childbirthdate3 = cast(NULL as date) ;
--  SET childbirthdate4 = cast(NULL as date) ;

RETURN

select
  coalesce(sum(x.TOTAL),0)
from
TABLE(
  func_pricingmisc_tbl
  (
    p_tocode
    ,p_misckey
    ,cast(nullif(p_startdate,'') as date)
    ,cast(nullif(p_returndate,'') as date)
    ,cast(nullif(p_currentdate,'') as date)
    ,p_nradults
    ,childbirthdate1
    ,childbirthdate2
    ,childbirthdate3
    ,childbirthdate4
  )
) as x

;
END @



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


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Function name: *func_pricing_tbl*

-- This function takes into account the occuancy in a room and assigns children
-- as adults should this be necessary. In a double room with one adult and one
-- child the child will be treated as an adult via the "func_roomvalid"
-- function.
-- Note: this function is only useful for a hotel pricing!
-- -----------------------------------------------------------------------------

drop function func_pricing_tbl @

create function func_pricing_tbl
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
   TABLE( func_roomvalid( p_tocode, p_itemkey, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4 ) ) AS x
  ,TABLE( func_pricing2_tbl( p_tocode, p_itemkey, 'H', p_startdate, p_returndate, p_currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) ) as pricing
WHERE
  func_test_price( p_tocode, p_itemkey, 'H', p_startdate, p_returndate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) = 'OK'
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


drop function func_pricing_tblch @

create function func_pricing_tblch
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
  SET currentdate = coalesce(cast(nullif(p_currentdate,'') as date), CURRENT DATE) ;
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
   TABLE( func_roomvalid( p_tocode, p_itemkey, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4 ) ) AS x
  ,TABLE( func_pricing2_tbl( p_tocode, p_itemkey, 'H', startdate, returndate, currentdate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) ) as pricing
WHERE
  func_test_price( p_tocode, p_itemkey, 'H', p_startdate, p_returndate, x.NRADULTS, x.CHILDBIRTHDATE1, x.CHILDBIRTHDATE2, x.CHILDBIRTHDATE3, x.CHILDBIRTHDATE4 ) = 'OK'
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


drop function func_pricing @

create function func_pricing
(
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
  func_pricing_tbl
  (
    p_tocode
    ,p_itemkey
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


drop function func_pricingch @

create function func_pricingch
(
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
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
  DECLARE currentdate DATE;

  SET childbirthdate1 = cast(nullif(p_childbirthdate1,'') as date) ;
  SET childbirthdate2 = cast(nullif(p_childbirthdate2,'') as date) ;
  SET childbirthdate3 = cast(nullif(p_childbirthdate3,'') as date) ;
  SET childbirthdate4 = cast(nullif(p_childbirthdate4,'') as date) ;
  SET currentdate = coalesce(cast(nullif(p_currentdate,'') as date), CURRENT DATE) ;

RETURN

select
  coalesce(sum(x.TOTAL),0)
from
TABLE(
  func_pricing_tbl
  (
    p_tocode
    ,p_itemkey
    ,cast(nullif(p_startdate,'') as date)
    ,cast(nullif(p_returndate,'') as date)
    ,currentdate
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



drop function func_hotelpriceav @

create function func_hotelpriceav
(
   IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN_DESTINATIONCODE VARCHAR(5) DEFAULT ''
  ,IN_PRICEDATEFROM VARCHAR(10)
  ,IN_PRICEDATETO VARCHAR(10)
  ,IN_NORMALOCCUPANCY INTEGER DEFAULT 2
  ,IN_HOTELCODE VARCHAR(30) DEFAULT ''
  ,IN_ROOMCODE VARCHAR(20) DEFAULT ''
  ,IN_TOURBOMEALCODE VARCHAR(5) DEFAULT ''
  ,IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN_ROOMKEY VARCHAR(20) DEFAULT ''
  ,IN_HOTELKEY VARCHAR(20) DEFAULT ''
)
RETURNS
  TABLE
  (
     TOCODE VARCHAR(5)
    ,ROOMKEY VARCHAR(20)
    ,TOTAL FLOAT
    ,STATUS VARCHAR(2)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE pricedatefrom DATE;
  DECLARE pricedateto DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;
  DECLARE currentdate DATE;

  SET pricedatefrom = cast(nullif(IN_PRICEDATEFROM, '') as date);
  SET pricedateto = cast(nullif(IN_PRICEDATETO, '') as date);
  SET childbirthdate1 = cast(nullif(IN_CHDDOB1, '') as date);
  SET childbirthdate2 = cast(nullif(IN_CHDDOB2, '') as date);
  SET childbirthdate3 = cast(nullif(IN_CHDDOB3, '') as date);
  SET childbirthdate4 = cast(nullif(IN_CHDDOB4, '') as date);
  SET currentdate = coalesce(cast(nullif(IN_CURRENTDATE, '') as date), CURRENT DATE);

RETURN

    -- #######################################################################
    -- # Returns sum of price for specific hotel item
    --
    --   Parameters for "func_pricing":
    --    p_tocode VARCHAR(5) DEFAULT ''
    --   ,p_itemkey VARCHAR(20) DEFAULT ''
    --   ,p_startdate DATE DEFAULT NULL -- start of booking period
    --   ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
    --   ,p_currentdate DATE DEFAULT CURRENT DATE
    --   ,p_nradults INTEGER DEFAULT 0
    --   ,p_childbirthdate1 DATE DEFAULT NULL
    --   ,p_childbirthdate2 DATE DEFAULT NULL
    --   ,p_childbirthdate3 DATE DEFAULT NULL
    --   ,p_childbirthdate4 DATE DEFAULT NULL
    --     
    --   Parameters for func_get_allotment2:
    --    p_tocode VARCHAR(5) DEFAULT ''
    --   ,p_itemkey VARCHAR(20) DEFAULT ''
    --   ,p_itemtype VARCHAR(1) DEFAULT ''
    --   ,p_startdate DATE DEFAULT NULL
    --   ,p_returndate DATE DEFAULT NULL
    --   ,p_currentdate DATE DEFAULT CURRENT DATE
    -- #######################################################################
    with tmptble (
      XHOTELKEY
      ,XROOMKEY
      ,XPRICE
      ,XALLTOMENTCODE
      )
    as (
      (
        select h.HOTELKEY
          ,r.ROOMKEY
          ,cast(func_pricing(IN_TOCODE, r.ROOMKEY, pricedatefrom, pricedateto, currentdate, IN_NORMALOCCUPANCY, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) as FLOAT) as price
          ,func_get_allotment2(IN_TOCODE, r.ROOMKEY, 'H', pricedatefrom, pricedateto, currentdate) as status
        from TOOHOTEL h
        INNER JOIN TOOROOMS r on h.HOTELKEY = r.HOTELKEY
        where h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
          and h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
          and r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
          and r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
          and r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
          and h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
          and r.NORMALOCCUPANCY = IN_NORMALOCCUPANCY
          and (
            coalesce(r.PASSIVE, 0) = 0
            or (
              r.PASSIVE = 1
              and coalesce(r.FROMDATE, current date) > current date
              )
            )
        )
      )
    select
       r.TOCODE as TOCODE
      ,r.ROOMKEY as ROOMKEY
      ,coalesce (XPRICE,0) as PRICE
      ,coalesce (XALLTOMENTCODE,'XX') as STATUS
    from
      TOOHOTEL h
      INNER JOIN TOOROOMS r on h.HOTELKEY = r.HOTELKEY
      LEFT OUTER JOIN tmptble on h.HOTELKEY = XHOTELKEY
      and r.ROOMKEY = XROOMKEY
    where
      r.TOCODE = IN_TOCODE
      and h.TOCODE = IN_TOCODE
      and h.DESTINATIONCODE = coalesce (nullif(IN_DESTINATIONCODE, ''),h.DESTINATIONCODE)
      and h.HOTELCODE = coalesce (nullif(IN_HOTELCODE, ''),h.HOTELCODE)
      and r.TOURBOCODE = coalesce (nullif(IN_ROOMCODE, ''),r.TOURBOCODE)
      and r.TOURBOMEALCODE = coalesce (nullif(IN_TOURBOMEALCODE, ''),r.TOURBOMEALCODE)
      and r.ROOMKEY = coalesce (nullif(IN_ROOMKEY, ''),r.ROOMKEY)
      and h.HOTELKEY = coalesce (nullif(IN_HOTELKEY, ''),h.HOTELKEY)
      and r.NORMALOCCUPANCY = IN_NORMALOCCUPANCY
      and (
            (IN_IGNORE_PRICE0 = 1 and XPRICE > 0)
           or IN_IGNORE_PRICE0 = 0
      )
      and coalesce (XALLTOMENTCODE,'XX') <>
            (
            case 
              when IN_IGNORE_XX = 1
                then 'XX'
              else '..'
              end
            )
      and coalesce (XALLTOMENTCODE,'XX') <> 
            (
            case 
              when IN_IGNORE_RQ = 1
                then 'RQ'
              else '..'
              end
            )
;
END @

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Zuerst die Funktionen löschen
-- -----------------------------------------------------------------------------

DROP PROCEDURE SP_PRICING_AV_HOTEL_TBL @
DROP PROCEDURE SP_PRICING_AV_HOTEL @
DROP PROCEDURE SP_PRICING_AV_MISC_TBL @
DROP PROCEDURE SP_PRICING_AV_MISC @

DROP FUNCTION func_miscpriceav2_tbl @
DROP FUNCTION func_miscpriceav2 @
DROP FUNCTION func_miscpriceav_ch @
DROP FUNCTION func_miscpriceav @
DROP FUNCTION func_miscpricebydest_ch @
DROP FUNCTION func_miscpricebydest @
DROP FUNCTION func_miscpricing @
DROP FUNCTION func_miscpricingch @
DROP FUNCTION func_miscpricing_tbl @
DROP FUNCTION func_miscpricing_tblch @

DROP FUNCTION func_hotelpriceav_tbl @
DROP FUNCTION func_pricing_tbl2 @
DROP FUNCTION func_hotelpriceav @

DROP FUNCTION func_roompricebydest_ch @
DROP FUNCTION func_roompricebydest @
DROP FUNCTION func_pricingch @
DROP FUNCTION func_pricing_tblch @
DROP FUNCTION func_pricing @
DROP FUNCTION func_pricing_tbl @
DROP FUNCTION func_pricing2 @
DROP FUNCTION func_pricing2_tbl @
DROP FUNCTION func_eb2_tbl @
DROP FUNCTION func_pricing3 @
DROP FUNCTION func_pricing3_tbl @
DROP FUNCTION func_spof3_tbl @
DROP FUNCTION func_all @
DROP FUNCTION func_all_tbl @
DROP FUNCTION func_roomvalid @
DROP FUNCTION func_miscvalid @
DROP FUNCTION func_getposdatedesc @
DROP FUNCTION elements2 @
DROP FUNCTION elemIdx2 @

DROP FUNCTION func_roompricebydest2 @
DROP FUNCTION func_pricing1 @
DROP FUNCTION func_pricing1_tbl @
DROP FUNCTION func_pricing_chd_tbl @
DROP FUNCTION func_pricing_adt_tbl @

-- EarlyBooking
DROP FUNCTION func_eb @
DROP FUNCTION func_eb_tbl @

-- SpecialOffer
DROP FUNCTION func_spof @
DROP FUNCTION func_spof_tbl @

-- OneTime
DROP FUNCTION func_ot @
DROP FUNCTION func_ot_tbl @

-- AddPerDayPrice
DROP FUNCTION func_apdp @
DROP FUNCTION func_apdp_tbl @

-- PerDayPrice
DROP FUNCTION func_pdp @
DROP FUNCTION func_pdp_tbl @

-- AddPeriodPrice
DROP FUNCTION func_app @
DROP FUNCTION func_app_tbl @

-- PeriodPrice
DROP FUNCTION func_pp @
DROP FUNCTION func_pp_tbl @

-- Helper functions
DROP FUNCTION elements2 @
DROP FUNCTION elemIdx2 @

-- -----------------------------------------------------------------------------
-- TOOHOTEL
-- -----------------------------------------------------------------------------

drop table TOOHOTEL @

create table TOOHOTEL
(
  hotelkey varchar(20) not null with default ''
  ,hotelnamede varchar(250) with default ''
  ,hotelnameen varchar(250) with default ''
  ,hotelnamefr varchar(250) with default ''
  ,hotelnameit varchar(250) with default ''
  ,address1 varchar(250) with default ''
  ,address2 varchar(250) with default ''
  ,postalcode varchar(50) with default ''
  ,city varchar(50) with default ''
  ,countryisocode varchar(50) with default ''
  ,country varchar(50) with default ''
  ,region varchar(50) with default ''
  ,subregion varchar(50) with default ''
  ,phonenumber varchar(50) with default ''
  ,phoneareacode varchar(50) with default ''
  ,phonecountryprefix varchar(50) with default ''
  ,faxnumber varchar(50) with default ''
  ,faxareacode varchar(50) with default ''
  ,faxcountryprefix varchar(50) with default ''
  ,mobilenumber varchar(20) with default ''
  ,mobileareacode varchar(20) with default ''
  ,mobilecountryprefix varchar(20) with default ''
  ,hotelchaincode varchar(20) with default ''
  ,hotelchain varchar(150) with default ''
  ,destinationcode varchar(5) with default ''
  ,countrycode varchar(10) with default ''
  ,hotelcode varchar(30) with default ''
  ,giataid varchar(20) with default ''
  ,longitude decimal(9,6) with default 0.0
  ,latitude decimal(9,6) with default 0.0
  ,apihotelcode varchar(50) with default ''
  ,category varchar(20) with default ''
  ,tocode varchar(5) not null with default ''
  ,PRIMARY key(hotelkey, tocode)
)
@

drop table TOOHOTEL2 @

create table TOOHOTEL2
(
  hotelkey varchar(20) not null with default ''
  ,tocode varchar(5) not null with default ''
  , PRIMARY key(hotelkey, tocode)
)
@

-- -----------------------------------------------------------------------------
-- TOOROOMS
-- -----------------------------------------------------------------------------

drop table TOOROOMS @

create table TOOROOMS
(
  hotelkey varchar(20) not null with default ''
  ,roomkey varchar(20) not null with default ''
  ,roomtypede varchar(250) with default ''
  ,roomtypeen varchar(250) with default ''
  ,roomtypefr varchar(250) with default ''
  ,roomtypeit varchar(250) with default ''
  ,descriptionde varchar(300) with default ''
  ,descriptionen varchar(300) with default ''
  ,descriptionfr varchar(300) with default ''
  ,descriptionit varchar(300) with default ''
  ,mealcode varchar(50) with default ''
  ,tourbomealcode varchar(5) with default ''
  ,mealdescriptionde varchar(300) with default ''
  ,mealdescriptionen varchar(300) with default ''
  ,mealdescriptionfr varchar(300) with default ''
  ,mealdescriptionit varchar(300) with default ''
  ,normaloccupancy integer with default 0
  ,minimaloccupancy integer with default 0
  ,maximaloccupancy integer with default 0
  ,maxadults integer with default 0
  ,extrabedadults integer with default 0
  ,extrabedchildren integer with default 0
  ,apihotelcode varchar(50) with default ''
  ,apiroomcode varchar(50) with default ''
  ,tourbocode varchar(20) with default ''
  ,category varchar(20) with default ''
  ,fromdate date
  ,passive integer with default 0
  ,tocode varchar(5) not null with default ''
  ,export integer with default 0
  ,PRIMARY key(roomkey, tocode)
)
@


drop table TOOROOMS2 @

create table TOOROOMS2
(
  roomkey varchar(20) not null with default ''
  ,tocode varchar(5) not null with default ''
  , PRIMARY key(roomkey, tocode)
)
@


-- -----------------------------------------------------------------------------
-- TOODESCRIPTIONS
-- -----------------------------------------------------------------------------

drop table TOODESCRIPTIONS @

create table TOODESCRIPTIONS
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,descid integer not null with default 0
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,descde varchar(140) with default ''
  ,descen varchar(140) with default ''
  ,descfr varchar(140) with default ''
  ,descit varchar(140) with default ''
  ,tocode varchar(5) not null with default ''
  ,itemtype varchar(1) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOODESCRIPTIONS volatile @

-- -----------------------------------------------------------------------------
-- TOOPERDAYPRICE
-- -----------------------------------------------------------------------------

drop table TOOPERDAYPRICE @

create table TOOPERDAYPRICE
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,day date not null
  ,price decimal(10,2) not null with default 0.0
  ,type varchar(20) not null with default ''
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,childidxnr integer not null with default 0
  ,descid integer not null with default 0
  ,notspecialrelevant integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,specialcommissionflag integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOPERDAYPRICE volatile @

-- -----------------------------------------------------------------------------
-- TOOPERDAYFLIGHTPRICE
-- -----------------------------------------------------------------------------

drop table TOOPERDAYFLIGHTPRICE @

create table TOOPERDAYFLIGHTPRICE
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,day date not null
  ,price decimal(10,2) not null with default 0.0
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,childidxnr integer not null with default 0
  ,descid integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- -----------------------------------------------------------------------------
-- TOOADDPERDAYPRICE
-- -----------------------------------------------------------------------------

drop table TOOADDPERDAYPRICE @

create table TOOADDPERDAYPRICE
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,day date not null
  ,price decimal(10,2) with default 0.0
  ,type varchar(20) with default ''
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,childidxnr integer not null with default 0
  ,descid integer not null with default 0
  ,notspecialrelevant integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,specialcommissionflag integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOADDPERDAYPRICE volatile @

-- -----------------------------------------------------------------------------
-- TOOONETIME
-- -----------------------------------------------------------------------------

drop table TOOONETIME @

create table TOOONETIME
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,datefrom date not null
  ,dateto date not null
  ,price decimal(10,2) not null with default 0.0
  ,descid integer not null with default 0
  ,type varchar(20) with default ''
  ,startdaterelevant integer not null with default 0
  ,enddaterelevant integer not null with default 0
  ,alwaysapply integer not null with default 0
  ,weekdaysvalid varchar(7) with default ''
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,baby integer not null with default 0
  ,child integer not null with default 0
  ,notspecialrelevant integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,specialcommissionflag integer not null with default 0
  ,tocode varchar(5) with default '' not null
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOONETIME volatile @

-- -----------------------------------------------------------------------------
-- TOOSPECIALOFFERS
-- -----------------------------------------------------------------------------

drop table TOOSPECIALOFFERS @

create table TOOSPECIALOFFERS
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,datefrom date not null
  ,dateto date not null
  ,fromdaybase integer not null with default 0
  ,todaybase integer not null with default 0
  ,daysbeforedeparturefrom integer not null with default 0
  ,daysbeforedepartureto integer not null with default 0
  ,datebeforedeparturefrom date
  ,datebeforedepartureto date
  ,paynights integer not null with default 0
  ,type varchar(20) with default ''
  ,revolvinggroup integer not null with default 0
  ,startdaterelevant integer not null with default 0
  ,enddaterelevant integer not null with default 0
  ,addamount decimal(10,2) with default 0.0
  ,descid integer not null with default 0
  ,weekdaysvalid varchar(7) with default ''
  ,lastspoffenddate date
  ,ruletype varchar(20) with default ''
  ,daystring varchar(80) not null with default ''
  ,days integer not null with default 0
  ,baby integer not null with default 0
  ,child integer not null with default 0
  ,childadultnr integer not null with default 0
  ,childchildnr integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,specialcommissionflag integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,combcode varchar (10) with default ''
  ,comblevel integer with default 0
  ,combindex integer with default 0
  ,notandcombcode varchar (10) with default ''
  ,notandcombminindex integer with default 0
  ,notandcombmaxindex integer with default 0
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOSPECIALOFFERS volatile @

-- -----------------------------------------------------------------------------
-- TOOEARLYBOOKINGS
-- -----------------------------------------------------------------------------

drop table TOOEARLYBOOKINGS @

create table TOOEARLYBOOKINGS
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,datefrom date not null
  ,dateto date not null
  ,fromday integer not null with default 0
  ,today integer not null with default 0
  ,daysbeforedeparturefrom integer not null with default 0
  ,daysbeforedepartureto integer not null with default 0
  ,datebeforedeparturefrom date
  ,datebeforedepartureto date
  ,percent decimal(6,2) not null with default 0.0
  ,startdaterelevant integer not null with default 0
  ,enddaterelevant integer not null with default 0
  ,addamount decimal(10,2) not null with default 0.0
  ,forcedisplay integer not null with default 0
  ,foralldays integer not null with default 0
  ,descid integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,ruletype varchar(20) with default ''
  ,weekdaysvalid varchar(7) with default ''
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,childidxnr integer not null with default 0
  ,specialcommissionflag integer not null with default 0
  ,onetime integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,combcode varchar (10) with default ''
  ,comblevel integer with default 0
  ,combindex integer with default 0
  ,notandcombcode varchar (10) with default ''
  ,notandcombminindex integer with default 0
  ,notandcombmaxindex integer with default 0
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOEARLYBOOKINGS volatile @

-- -----------------------------------------------------------------------------
-- TOOALLOTMENTS
-- -----------------------------------------------------------------------------

drop table TOOALLOTMENTS @

create table TOOALLOTMENTS
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,allotdate date not null
  ,av decimal(6,2) not null with default 0.0
  ,rel date
  ,minstay date
  ,rq integer not null with default 0
  ,fs integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,maxstay date
  ,arrivalok integer with default 1
  ,departureok integer with default 1
  ,noarrival integer with default 0
  ,nodeparture integer with default 0
  ,itemtype varchar(1) with default ''
  ,deptime time
  ,arrtime time
  ,carrier varchar(30) with default ''
  ,flightnr varchar(30) with default ''
  ,checkinminbeforedep integer with default 0
  ,checkintimedev integer with default 0
  ,PRIMARY key(id)
)
@

-- alter table TOOALLOTMENTS volatile @

-- -----------------------------------------------------------------------------
-- TOOCANCELLATIONS
-- -----------------------------------------------------------------------------

drop table TOOCANCELLATIONS @

create table TOOCANCELLATIONS
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,internalpricetype varchar(20) with default ''
  ,begindate date not null
  ,enddate date not null
  ,percent decimal(6,2) not null with default 0.0
  ,amount decimal(10,2) not null with default 0.0
  ,daybeforedeparturebegin integer with default 0
  ,daybeforedepartureend integer with default 0
  ,nrdaysfeeapply integer with default 0
  ,pricetype varchar(20) with default ''
  ,tocode varchar(5) not null with default ''
  ,itemtype varchar(1) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOCANCELLATIONS volatile @

-- -----------------------------------------------------------------------------
-- TOOITEMINFOS
-- -----------------------------------------------------------------------------

drop table TOOITEMINFOS @

create table TOOITEMINFOS
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,begindate date not null
  ,enddate date not null
  ,type varchar(20) with default ''
  ,invoice integer not null with default 0
  ,itinerary integer not null with default 0
  ,external integer not null with default 0
  ,titlede varchar(100) with default ''
  ,titleen varchar(100) with default ''
  ,titlefr varchar(100) with default ''
  ,titleit varchar(100) with default ''
  ,textde varchar(500) with default ''
  ,texten varchar(500) with default ''
  ,textfr varchar(500) with default ''
  ,textit varchar(500) with default ''
  ,tocode varchar(5) not null with default ''
  ,itemtype varchar(1) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOITEMINFOS volatile @

-- -----------------------------------------------------------------------------
-- TOOPERIODPRICE
-- -----------------------------------------------------------------------------

drop table TOOPERIODPRICE @

-- Identisch mit TOOONETIMES, nur mit einer zusätzlichen Spalte "nrnights"
create table TOOPERIODPRICE
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,datefrom date not null
  ,dateto date not null
  ,price decimal(10,2) not null with default 0.0
  ,descid integer not null with default 0
  ,type varchar(20) with default ''
  ,startdaterelevant integer not null with default 0
  ,enddaterelevant integer not null with default 0
  ,alwaysapply integer not null with default 0
  ,weekdaysvalid varchar(7) with default ''
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,baby integer not null with default 0
  ,child integer not null with default 0
  ,notspecialrelevant integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,specialcommissionflag integer not null with default 0
  ,nrnights integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,pricetype varchar(10) with default ''
  ,PRIMARY KEY(id)
)
@

-- alter table TOOPERIODPRICE volatile @

-- -----------------------------------------------------------------------------
-- TOOADDPERIODPRICE
-- -----------------------------------------------------------------------------

drop table TOOADDPERIODPRICE @

-- Identisch mit TOOPERIODPRICE, nur mit einer zusätzlichen Spalte "pricepernight"
create table TOOADDPERIODPRICE
(
  id integer not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,parentkey varchar(20) not null with default ''
  ,itemkey varchar(20) not null with default ''
  ,currency varchar(3) with default ''
  ,datefrom date not null
  ,dateto date not null
  ,price decimal(10,2) not null with default 0.0
  ,descid integer not null with default 0
  ,type varchar(20) with default ''
  ,startdaterelevant integer not null with default 0
  ,enddaterelevant integer not null with default 0
  ,alwaysapply integer not null with default 0
  ,weekdaysvalid varchar(7) with default ''
  ,agefrom integer not null with default 0
  ,ageto integer not null with default 0
  ,baby integer not null with default 0
  ,child integer not null with default 0
  ,notspecialrelevant integer not null with default 0
  ,specialcommission decimal(6,2) not null with default 0.0
  ,specialcommissionflag integer not null with default 0
  ,nrnights integer not null with default 0
  ,pricepernight integer not null with default 0
  ,tocode varchar(5) not null with default ''
  ,p_seq varchar(20) with default '' -- FK to TO Online price row
  ,itemtype varchar(1) with default ''
  ,pricetype varchar(10) with default ''
  ,PRIMARY key(id)
)
@

-- alter table TOOPERIODPRICE volatile @

-- -----------------------------------------------------------------------------
-- TOOTMPDAY
-- -----------------------------------------------------------------------------

drop table TOOTMPDAY @

create table TOOTMPDAY (TMPDAY DATE NOT NULL, PRIMARY KEY(TMPDAY)) @

INSERT INTO TOOTMPDAY (TMPDAY)
WITH DATERANGE(LEVEL,DT) AS
(
  SELECT
    1
    ,current date + (1 - day(current date)) days - 2 months 
  FROM SYSIBM.SYSDUMMY1 
  UNION ALL
  SELECT
    LEVEL + 1
    ,DT + 1 DAY 
  FROM
    DATERANGE 
  WHERE
    LEVEL < 3000
    AND DT < current date + (1 - day(current date)) days - 1 day + 2 years
)
SELECT
  DT
FROM
  DATERANGE
WHERE NOT EXISTS (SELECT TMPDAY FROM TOOTMPDAY WHERE TMPDAY=DT)
@

-- -----------------------------------------------------------------------------
-- TOOMISC
-- -----------------------------------------------------------------------------

drop table TOOMISC @

create table TOOMISC
(
  misckey VARCHAR(20) not null with default ''
  ,tocode VARCHAR(5) not null with default ''
  ,title VARCHAR(50) not null with default ''
  ,country VARCHAR(50) not null with default ''
  ,countryisocode VARCHAR(50) not null with default ''
  ,region VARCHAR(50) not null with default ''
  ,subregion VARCHAR(50) not null with default ''
  ,destinationcode VARCHAR(50) not null with default ''
--  ,suppliername VARCHAR(100) not null with default ''
--  ,suppliercode VARCHAR(30) not null with default ''
--  ,suppliernr INTEGER not null with default 0
--  ,vouchersuppliername VARCHAR(100) not null with default ''
--  ,vouchersuppliercode VARCHAR(30) not null with default ''
--  ,vouchersuppliernr INTEGER not null with default 0
--  ,paysuppliername VARCHAR(100) not null with default ''
--  ,paysuppliercode VARCHAR(30) not null with default ''
--  ,paysuppliernr INTEGER not null with default 0
  ,minimumpersons INTEGER not null with default 0
  ,maximumpersons INTEGER not null with default 0
  ,minimumdays INTEGER not null with default 0
  ,maximumdays INTEGER not null with default 0
  ,passive INTEGER not null with default 0
  ,passivefromdate DATE
  ,startdaterelevant INTEGER not null with default 0
  ,outbound INTEGER not null with default 0
  ,inbound INTEGER not null with default 0
  ,tourbotitle VARCHAR(80) not null with default ''
  ,misccode VARCHAR(10) not null with default ''
  ,miscitemcode VARCHAR(10) not null with default ''
  ,overnight INTEGER not null with default 0
  ,export integer with default 0
  ,PRIMARY key(misckey, tocode)
)
@

drop table TOOMISC2 @

create table TOOMISC2
(
  misckey varchar(20) not null with default ''
  ,tocode varchar(5) not null with default ''
  , PRIMARY key(misckey, tocode)
)
@

-- -----------------------------------------------------------------------------
-- TOOMISCHOTEL
-- -----------------------------------------------------------------------------

drop table TOOMISCHOTEL @

create table TOOMISCHOTEL
(
  id INTEGER not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,tocode VARCHAR(5) not null with default ''
  ,misckey VARCHAR(20) not null with default ''
  ,hotelkey VARCHAR(20) not null with default ''
  ,PRIMARY key(id)
)
@
-- -----------------------------------------------------------------------------
-- TOOMISCTEXT
-- -----------------------------------------------------------------------------

drop table TOOMISCTEXT @

create table TOOMISCTEXT
(
  id INTEGER not null generated by default as identity ( start with 1 increment by 1 no cache )
  ,misckey VARCHAR(20) not null with default ''
  ,tocode VARCHAR(5) not null with default ''
  ,lang VARCHAR(2) not null with default ''  -- EN, FR, IT, DE
  ,type VARCHAR(5) not null with default ''  -- INV = Invoice text, ITIN = Itinerary text, VCHR = Voucher text
  ,title VARCHAR(120) not null with default ''
  ,detail VARCHAR(3600) not null with default ''
  ,PRIMARY key(id)
)
@

-- -----------------------------------------------------------------------------
-- TOOARRANGEMENT
-- -----------------------------------------------------------------------------

drop table TOOARRANGEMENT @

create table TOOARRANGEMENT
(
  arrkey VARCHAR(20) not null with default ''
  ,tocode VARCHAR(5) not null with default ''
  ,arrlang VARCHAR(2) not null with default ''
  ,shorttitle VARCHAR(100) not null with default ''
  ,destinationcode VARCHAR(50) not null with default ''
  ,arrcode VARCHAR(10) not null with default ''
  ,arritemcode VARCHAR(10) not null with default ''
  ,country VARCHAR(50) not null with default ''
  ,countryisocode VARCHAR(50) not null with default ''
  ,region VARCHAR(50) not null with default ''
  ,subregion VARCHAR(50) not null with default ''
--  ,suppliername VARCHAR(100) not null with default ''
--  ,suppliercode VARCHAR(30) not null with default ''
--  ,suppliernr INTEGER not null with default 0
--  ,vouchersuppliername VARCHAR(100) not null with default ''
--  ,vouchersuppliercode VARCHAR(30) not null with default ''
--  ,vouchersuppliernr INTEGER not null with default 0
--  ,paysuppliername VARCHAR(100) not null with default ''
--  ,paysuppliercode VARCHAR(30) not null with default ''
--  ,paysuppliernr INTEGER not null with default 0
  ,normaloccupancy integer with default 0
  ,extrabedadults integer with default 0
  ,extrabedchildren integer with default 0
  ,invtitle VARCHAR(100) not null with default ''
  ,invtext VARCHAR(3000) not null with default ''
  ,passive INTEGER not null with default 0
  ,passivefromdate DATE
  ,export integer with default 0
  ,PRIMARY key(arrkey, tocode)
)
@

drop table TOOARRANGEMENT2 @

create table TOOARRANGEMENT2
(
  arrkey varchar(20) not null with default ''
  ,tocode varchar(5) not null with default ''
  , PRIMARY key(arrkey, tocode)
)
@

-- -----------------------------------------------------------------------------
-- TOOFLIGHT
-- -----------------------------------------------------------------------------

drop table TOOFLIGHT @

create table TOOFLIGHT
(
   flightkey varchar(20) with default ''
  ,tocode varchar(5) with default ''
  ,dep varchar(5) with default ''
  ,arr varchar(5) with default ''
  ,carrier varchar(30) with default ''
  ,flightnr varchar(30) with default ''
  ,class varchar(30) with default ''
  ,classdesc varchar(100) with default ''
  ,seatclass varchar(30) with default ''
  ,seatclassnr integer with default 0
  ,destinationcode varchar(50) with default ''
  ,passive integer with default 0
  ,passivefromdate date
  ,multileg integer with default 0
  ,PRIMARY key(flightkey, tocode)
)
@

drop table TOOFLIGHTLEG @

create table TOOFLIGHTLEG
(
  legkey varchar(20) with default ''
  ,flightkey varchar(20) with default ''
  ,tocode varchar(5) with default ''
  ,dep varchar(5) with default ''
  ,arr varchar(5) with default ''
  ,carrier varchar(30) with default ''
  ,flightnr varchar(30) with default ''
  ,class varchar(30) with default ''
  ,classdesc varchar(100) with default ''
  ,seatclass varchar(30) with default ''
  ,seatclassnr integer with default 0
  ,checkinminbeforedep integer with default 0
  ,checkintimedev integer with default 0
  ,feeder integer with default 0
  ,pos integer with default 0
  ,export integer with default 0
  ,PRIMARY key(legkey, tocode)
)
@

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

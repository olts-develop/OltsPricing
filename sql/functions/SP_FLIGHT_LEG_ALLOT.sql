CREATE
  OR REPLACE PROCEDURE SP_FLIGHT_LEG_ALLOT (
  IN IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN IN_DEPAIRPORTCODE VARCHAR(5) DEFAULT ''
  ,IN IN_ARRAIRPORTCODE VARCHAR(5) DEFAULT ''
  ,IN IN_DATEFROM VARCHAR(10)
  ,IN IN_DATETO VARCHAR(10)
  ) DYNAMIC RESULT SETS 1

P1:

BEGIN
  DECLARE cursor1 CURSOR WITH RETURN
  FOR
  select
    TOOFLIGHTLEG.LEGKEY
    ,TOOFLIGHTLEG.FLIGHTKEY
    ,TOOFLIGHTLEG.TOCODE
    ,TOOFLIGHTLEG.DEP
    ,TOOFLIGHTLEG.ARR
    ,TOOFLIGHTLEG.CARRIER
    ,TOOFLIGHTLEG.FLIGHTNR
    ,TOOFLIGHTLEG.CLASS
    ,TOOFLIGHTLEG.CLASSDESC
    ,TOOFLIGHTLEG.SEATCLASS
    ,TOOFLIGHTLEG.SEATCLASSNR
    ,TOOALLOTMENTS.ALLOTDATE
    ,TOOALLOTMENTS.AV
    ,TOOALLOTMENTS.REL
    ,TOOALLOTMENTS.MINSTAY
    ,TOOALLOTMENTS.RQ
    ,TOOALLOTMENTS.FS
    ,TOOALLOTMENTS.MAXSTAY
    ,TOOALLOTMENTS.ARRIVALOK
    ,TOOALLOTMENTS.DEPARTUREOK
    ,TOOALLOTMENTS.NOARRIVAL
    ,TOOALLOTMENTS.NODEPARTURE
    ,TOOALLOTMENTS.DEPTIME
    ,TOOALLOTMENTS.ARRTIME
    ,TOOALLOTMENTS.ARRTIMEDEV
    ,TOOALLOTMENTS.CARRIER
    ,TOOALLOTMENTS.FLIGHTNR
    ,TOOALLOTMENTS.CHECKINMINBEFOREDEP
    ,TOOALLOTMENTS.CHECKINTIMEDEV
  from TOOFLIGHTLEG
  INNER JOIN TOOALLOTMENTS on TOOALLOTMENTS.ITEMKEY = TOOFLIGHTLEG.LEGKEY
             and TOOALLOTMENTS.ITEMTYPE = 'F'
  where
    TOOALLOTMENTS.ALLOTDATE between
       cast(coalesce(nullif(IN_DATEFROM,''),current date) as date)
       and cast(coalesce(nullif(IN_DATETO,''),current date) as date)
    and TOOFLIGHTLEG.DEP = coalesce(NULLIF(IN_DEPAIRPORTCODE,''), TOOFLIGHTLEG.DEP)
    and TOOFLIGHTLEG.ARR = coalesce(NULLIF(IN_ARRAIRPORTCODE,''), TOOFLIGHTLEG.ARR)
    and TOOFLIGHTLEG.TOCODE = coalesce(NULLIF(IN_TOCODE,''),TOOFLIGHTLEG.TOCODE)
    and TOOALLOTMENTS.TOCODE = coalesce(NULLIF(IN_TOCODE,''),TOOALLOTMENTS.TOCODE)
  for read only;

  -- Cursor left open for client application
  OPEN cursor1;
END P1
@

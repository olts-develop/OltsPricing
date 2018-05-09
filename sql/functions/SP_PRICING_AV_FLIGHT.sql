CREATE
  OR REPLACE PROCEDURE SP_PRICING_AV_FLIGHT1 (
  IN IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN IN_DEPAIRPORTCODE VARCHAR(5) DEFAULT ''
  ,IN IN_ARRAIRPORTCODE VARCHAR(5) DEFAULT ''
  ,IN IN_PRICEDATEFROM VARCHAR(10)
  ,IN IN_PRICEDATETO VARCHAR(10)
  ,IN IN_NRADULTS INTEGER DEFAULT 2
  ,IN IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN IN_FLIGHTKEY VARCHAR(20) DEFAULT ''
  ,IN IN_CURRENCY VARCHAR(3) DEFAULT 'CHF'
  ,IN IN_EXPORT_ONLY INTEGER DEFAULT 1
  ) DYNAMIC RESULT SETS 1
P1:
BEGIN
  DECLARE cursor1 CURSOR WITH RETURN
  FOR
  
  with tmptbl (PRICETOTAL,ALLOTMENT,DEPTS,ARRTS,CARRIER,FLIGHTNR,CHECKINMINBEFOREDEP,CHECKINTIMEDEV,FLIGHTKEY,LEGKEY,TOCODE,FLIGHTDAY,LEGDAY,POS) as
    (
     select
        func_flightpricing(TOOFLIGHTLEG.TOCODE, TOOFLIGHTLEG.LEGKEY, TOOFLIGHTLEGDAY.LEGDAY, cast(coalesce(nullif(IN_CURRENTDATE,''),current date) as date), IN_NRADULTS, cast(nullif(IN_CHDDOB1,'') as date), cast(nullif(IN_CHDDOB2,'') as date), cast(nullif(IN_CHDDOB3,'') as date), cast(nullif(IN_CHDDOB4,'') as date), IN_CURRENCY) AS PRICETOTAL
        ,func_get_allotment2ch('', TOOFLIGHTLEG.LEGKEY, 'F', cast(TOOFLIGHTLEGDAY.LEGDAY as VARCHAR(10)), cast((TOOFLIGHTLEGDAY.LEGDAY + 1 day) as VARCHAR(10)), IN_CURRENTDATE ) as ALLOTMENT
        
        ,cast(timestamp (coalesce(TOOFLIGHTLEGDAY.LEGDAY,TOOALLOTMENTS.ALLOTDATE),TOOALLOTMENTS.DEPTIME) as char(26)) as DEPTS
        ,cast(timestamp (TOOALLOTMENTS.ALLOTDATE + TOOALLOTMENTS.ARRTIMEDEV days,TOOALLOTMENTS.ARRTIME) as char(26)) as ARRTS
        ,coalesce(nullif(TOOALLOTMENTS.CARRIER,''),TOOFLIGHTLEG.CARRIER) as CARRIER
        ,coalesce(nullif(TOOALLOTMENTS.FLIGHTNR,''),TOOFLIGHTLEG.FLIGHTNR) as FLIGHTNR
        ,coalesce(nullif(TOOALLOTMENTS.CHECKINMINBEFOREDEP,0),TOOFLIGHTLEG.CHECKINMINBEFOREDEP) as CHECKINMINBEFOREDEP
        ,coalesce(nullif(TOOALLOTMENTS.CHECKINTIMEDEV,0),TOOFLIGHTLEG.CHECKINTIMEDEV) as CHECKINTIMEDEV
        
        ,TOOFLIGHTLEGDAY.FLIGHTKEY
        ,TOOFLIGHTLEGDAY.LEGKEY
        ,TOOFLIGHTLEGDAY.TOCODE
        ,TOOFLIGHTLEGDAY.FLIGHTDAY
        ,TOOFLIGHTLEGDAY.LEGDAY
        ,TOOFLIGHTLEGDAY.POS
        
      FROM
        TOOFLIGHT
        inner join TOOFLIGHTLEG on TOOFLIGHT.FLIGHTKEY = TOOFLIGHTLEG.FLIGHTKEY
        inner join TOOFLIGHTLEGDAY on TOOFLIGHTLEGDAY.FLIGHTKEY=TOOFLIGHT.FLIGHTKEY and TOOFLIGHTLEGDAY.LEGKEY=TOOFLIGHTLEG.LEGKEY
        left outer join TOOALLOTMENTS on TOOALLOTMENTS.ITEMKEY = TOOFLIGHTLEGDAY.LEGKEY and TOOALLOTMENTS.ITEMTYPE='F' and TOOALLOTMENTS.ALLOTDATE=TOOFLIGHTLEGDAY.LEGDAY
      where
        TOOFLIGHTLEGDAY.LEGDAY between IN_PRICEDATEFROM and IN_PRICEDATETO
        and TOOFLIGHT.DEP=coalesce(nullif(IN_DEPAIRPORTCODE,''),TOOFLIGHT.DEP)
        and TOOFLIGHT.ARR=coalesce(nullif(IN_ARRAIRPORTCODE,''),TOOFLIGHT.ARR)
        and TOOFLIGHT.TOCODE=coalesce(IN_TOCODE,'')
        and TOOFLIGHTLEG.TOCODE=coalesce(IN_TOCODE,'')
        and TOOFLIGHTLEGDAY.TOCODE=coalesce(IN_TOCODE,'')
        and TOOALLOTMENTS.TOCODE=coalesce(IN_TOCODE,'')
        and TOOFLIGHT.FLIGHTKEY=coalesce(nullif(IN_FLIGHTKEY,''),TOOFLIGHT.FLIGHTKEY)
    )
    ,tmptbl1 (PRICETOTAL,ALLOTMENT,DEPTS,ARRTS,CARRIER,FLIGHTNR,CHECKINMINBEFOREDEP,CHECKINTIMEDEV,FLIGHTKEY,LEGKEY,TOCODE,FLIGHTDAY,LEGDAY,POS,LEGJSON,LEGXML) as
    (
      select
         tmptbl.PRICETOTAL AS PRICETOTAL
        ,tmptbl.ALLOTMENT as ALLOTMENT
        ,tmptbl.DEPTS as DEPTS
        ,tmptbl.ARRTS as ARRTS
        ,tmptbl.CARRIER as CARRIER
        ,tmptbl.FLIGHTNR as FLIGHTNR
        ,tmptbl.CHECKINMINBEFOREDEP as CHECKINMINBEFOREDEP
        ,tmptbl.CHECKINTIMEDEV as CHECKINTIMEDEV
        ,tmptbl.FLIGHTKEY as FLIGHTKEY
        ,tmptbl.LEGKEY as LEGKEY
        ,tmptbl.TOCODE as TOCODE
        ,tmptbl.FLIGHTDAY as FLIGHTDAY
        ,tmptbl.LEGDAY as LEGDAY
        ,tmptbl.POS as POS
        ,'{' || '"LegPrice":"'     || coalesce(tmptbl.PRICETOTAL,0.00) || '", '
             || '"LegAllotment":"' || coalesce(tmptbl.ALLOTMENT,'XX')  || '", '
             || '"LegKey":"' || coalesce(tmptbl.LEGKEY,'')  || '", '
             || '"LegDepTS":"' || coalesce(tmptbl.DEPTS,'')  || '", '
             || '"LegArrTS":"' || coalesce(tmptbl.ARRTS,'')  || '", '
             || '"LegCarrier":"' || coalesce(tmptbl.CARRIER,'')  || '", '
             || '"LegFlightNr":"' || coalesce(tmptbl.FLIGHTNR,'')  || '", '
             || '"LegPos":"' || coalesce(tmptbl.POS,'')  || '", '
             || '"LegDep":"' || coalesce(TOOFLIGHTLEG.DEP,'')  || '", '
             || '"LegArr":"' || coalesce(TOOFLIGHTLEG.ARR,'')  || '", '
             || '"CheckInMinBeforeDep":"' || coalesce(tmptbl.CHECKINMINBEFOREDEP,0)  || '", '
             || '"CheckInTimeDev":"' || coalesce(tmptbl.CHECKINTIMEDEV,0)  || '", '
             || '"Class":"' || coalesce(TOOFLIGHTLEG.CLASS,'')  || '", '
             || '"ClassDesc":"' || coalesce(TOOFLIGHTLEG.CLASSDESC,'')  || '", '
             || '"SeatClass":"' || coalesce(TOOFLIGHTLEG.SEATCLASS,'')  || '", '
             || '"SeatClassNr":"' || coalesce(TOOFLIGHTLEG.SEATCLASSNR,'')  || '"'
             || '}'
        ,
          XMLELEMENT(
        NAME "Leg"
          , XMLATTRIBUTES(
            tmptbl.PRICETOTAL as "LegPrice"
            ,tmptbl.ALLOTMENT as "LegAllotment"
            ,tmptbl.LEGKEY as "LegKey"
            , tmptbl.DEPTS as "LegDepTS"
            , tmptbl.ARRTS as "LegArrTS"
            , tmptbl.CARRIER as "LegCarrier"
            , tmptbl.FLIGHTNR as "LegFlightNr"
            , tmptbl.POS as "LegPos"
            ,TOOFLIGHTLEG.DEP as "LegDep"
            ,TOOFLIGHTLEG.ARR as "LegArr"
            ,tmptbl.CHECKINMINBEFOREDEP as "CheckInMinBeforeDep"
            ,tmptbl.CHECKINTIMEDEV as "CheckInTimeDev"
            ,TOOFLIGHTLEG.CLASS as "Class"
            ,TOOFLIGHTLEG.CLASSDESC as "ClassDesc"
            ,TOOFLIGHTLEG.SEATCLASS as "SeatClass"
            ,TOOFLIGHTLEG.SEATCLASSNR as "SeatClassNr"
          )
          ) 
             
      FROM
        tmptbl
        inner join TOOFLIGHTLEG on TOOFLIGHTLEG.FLIGHTKEY = tmptbl.FLIGHTKEY and TOOFLIGHTLEG.LEGKEY = tmptbl.LEGKEY and TOOFLIGHTLEG.TOCODE = tmptbl.TOCODE
        inner join TOOFLIGHTLEGDAY on TOOFLIGHTLEGDAY.FLIGHTKEY=TOOFLIGHTLEG.FLIGHTKEY and TOOFLIGHTLEGDAY.LEGKEY=TOOFLIGHTLEG.LEGKEY and TOOFLIGHTLEGDAY.TOCODE=TOOFLIGHTLEG.TOCODE and TOOFLIGHTLEGDAY.LEGDAY=tmptbl.LEGDAY
      
      WHERE        
        TOOFLIGHTLEG.FLIGHTKEY = tmptbl.FLIGHTKEY and TOOFLIGHTLEG.LEGKEY = tmptbl.LEGKEY and TOOFLIGHTLEG.TOCODE = tmptbl.TOCODE
        and TOOFLIGHTLEGDAY.FLIGHTKEY=TOOFLIGHTLEG.FLIGHTKEY and TOOFLIGHTLEGDAY.LEGKEY=TOOFLIGHTLEG.LEGKEY and TOOFLIGHTLEGDAY.TOCODE=TOOFLIGHTLEG.TOCODE and TOOFLIGHTLEGDAY.LEGDAY=tmptbl.LEGDAY
    )
  ,tmptbl2 (FLIGHTKEY, TOCODE, FLIGHTDAY, PRICETOTAL, COUNTXX, COUNTRQ, LEGCOUNT, MINALLOTMENT, DEPTS, ARRTS, LEGJSON, LEGXML) as
    (
      select
      tmptbl1.FLIGHTKEY
      ,max(tmptbl1.TOCODE)
      ,tmptbl1.FLIGHTDAY
      ,case
    when max(TOOFLIGHT.MULTILEG)=1 then
         coalesce(
           nullif(
             sum(
               func_flightpricing(TOOFLIGHT.TOCODE
                         , TOOFLIGHT.FLIGHTKEY
                         , cast(tmptbl1.FLIGHTDAY as VARCHAR(10))
                         , cast(coalesce(nullif(IN_CURRENTDATE,''),current date) as date)
                         , IN_NRADULTS, cast(nullif(IN_CHDDOB1,'') as date)
                         , cast(nullif(IN_CHDDOB2,'') as date)
                         , cast(nullif(IN_CHDDOB3,'') as date)
                         , cast(nullif(IN_CHDDOB4,'') as date)
                         , IN_CURRENCY
                         )
                     ),0)
                     ,sum(tmptbl1.PRICETOTAL),0)
    when max(TOOFLIGHT.MULTILEG)=0 and count(case when tmptbl1.PRICETOTAL<>0 then 1 else 0 end)=count(tmptbl1.LEGKEY) then
          sum(tmptbl1.PRICETOTAL)
         else
          0
         end
      as "PriceTotal"
      ,sum(case when tmptbl1.ALLOTMENT='XX' then 1 else 0 end) as COUNTXX
      ,sum(case when tmptbl1.ALLOTMENT='RQ' then 1 else 0 end) as COUNTRQ
      ,count(*)
      ,min(case when isnumeric(tmptbl1.ALLOTMENT)=1 then cast(tmptbl1.ALLOTMENT as INTEGER) else 0 end) as MINALLOTMENT
      ,min(tmptbl1.DEPTS) as DEPTS
      ,max(tmptbl1.ARRTS) as ARRTS
      ,'{"Legs":[' || LISTAGG(tmptbl1.LEGJSON, ', ') WITHIN GROUP (ORDER BY tmptbl1.POS) || ']}'
      ,XML2CLOB( 
        XMLELEMENT(
        NAME "Legs"
        ,XMLAGG(
                tmptbl1.LEGXML ORDER BY tmptbl1.POS        
        )
        )
      )
            
      FROM
        tmptbl1
        inner join TOOFLIGHT on TOOFLIGHT.FLIGHTKEY=tmptbl1.FLIGHTKEY and TOOFLIGHT.TOCODE=tmptbl1.TOCODE
      GROUP BY 
        tmptbl1.FLIGHTKEY, tmptbl1.FLIGHTDAY, tmptbl1.TOCODE
    )
  
  SELECT
    MAX(TOOFLIGHT.TOCODE) as TOCODE
    ,TOOFLIGHT.FLIGHTKEY as FLIGHTKEY
    ,max(TOOFLIGHT.DEP) as DEP
    ,max(TOOFLIGHT.ARR) as ARR
    ,max(TOOFLIGHT.CARRIER) as CARRIER
    ,max(TOOFLIGHT.FLIGHTNR) as FLIGHTNR
    ,max(TOOFLIGHT.CLASS) as CLASS
    ,max(TOOFLIGHT.CLASSDESC) as CLASSDESC
    ,max(TOOFLIGHT.SEATCLASS) as SEATCLASS
    ,max(TOOFLIGHT.SEATCLASSNR) as SEATCLASSNR
    ,max(TOOFLIGHT.DESTINATIONCODE) as DESTINATIONCODE
    ,max(TOOFLIGHT.PASSIVE) as PASSIVE
    ,max(TOOFLIGHT.PASSIVEFROMDATE) as PASSIVEFROMDATE
    ,max(TOOFLIGHT.MULTILEG) as MULTILEG
    ,max(tmptbl2.LEGCOUNT) as "FlightLegCount"
    ,min(tmptbl2.DEPTS) as "DepTS"
    ,max(tmptbl2.ARRTS) as "ArrTS"
    ,coalesce(sum(tmptbl2.PRICETOTAL),0) as "PriceSum"
    ,max(case when tmptbl2.COUNTXX>0 then 'XX' when tmptbl2.COUNTRQ>0 then 'RQ' else cast(tmptbl2.MINALLOTMENT as varchar(10)) end ) as "Allotment"
    ,max(cast(tmptbl2.LEGJSON as VARCHAR(4000))) as "LegJson"
    ,max(cast(tmptbl2.LEGXML as VARCHAR(4000))) as "LegXml"   
  FROM
    tmptbl2
    inner join TOOFLIGHT on TOOFLIGHT.FLIGHTKEY = tmptbl2.FLIGHTKEY and TOOFLIGHT.TOCODE = tmptbl2.TOCODE
    
  WHERE
    (
      coalesce(IN_IGNORE_XX,0) = 0
      or IN_IGNORE_XX=1 and tmptbl2.COUNTXX = 0
    )
    and 
    (
      coalesce(IN_IGNORE_RQ,0) = 0
      or IN_IGNORE_RQ=1 and tmptbl2.COUNTRQ = 0
    )
    and 
    (
      coalesce(IN_IGNORE_PRICE0,0) = 0
      or IN_IGNORE_PRICE0=1 and coalesce(tmptbl2.PRICETOTAL,0) <> 0
    )
    
  GROUP BY
    TOOFLIGHT.FLIGHTKEY
    ,tmptbl2.FLIGHTDAY
  ;
  -- Cursor left open for client application
  OPEN cursor1;
END P1
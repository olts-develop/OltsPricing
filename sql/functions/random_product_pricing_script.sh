db2 "connect to HOTEL user db2inst1 using ibmdb2"
db2 -x "with tmpcodedest (tmptocode,tmpdestcode) as (
    select distinct s1.TOCODE,s1.DESTINATIONCODE from TOOHOTEL s1 tablesample bernoulli(10) where s1.TOCODE in ('','TSOL','KNE','STOH') and coalesce(s1.DESTINATIONCODE,'')<>''
    )
    , tmpparams (tmptocode,tmpdestcode,tmprand,tmpstartdate,tmpnrdays) as (
    select
    tmpcodedest.tmptocode
    ,tmpcodedest.tmpdestcode
    ,RAND()
    ,current date + ( int(rand() * 150) ) days
    ,(int(rand() * 21)) + 1
    from
    tmpcodedest
    order by 3 asc
    fetch first 1 row only
    )
    select
     ''''||tmptocode||''''
    ,''''||tmpdestcode||''''
    ,''''||cast(tmpstartdate as char(10))||''''
    ,''''||cast(tmpstartdate + tmpnrdays days as char(10))||''''
    from tmpparams" | while read tmptocode tmpdestcode tmpstartdate tmpenddate ; do
  echo ---------------------------------------------
  echo TOCODE=$tmptocode
  echo DESTINATIONCODE=$tmpdestcode
  echo STARTDATE=$tmpstartdate
  echo ENDDATE=$tmpenddate
  echo ---------------------------------------------
    
    db2 "connect to HOTEL user db2inst1 using ibmdb2"
    
    START=$(date +%s)
    echo START=$START
    
    db2 "with tmptble (xhotelkey, xroomkey, xprice, xalltomentcode) AS 
    (
    (
    SELECT
    h.hotelkey
    , r.roomkey
    , func_pricingch($tmptocode, r.roomkey, $tmpstartdate, $tmpenddate, '', 2, '', '', '', '') AS price
    , func_get_allotment2ch($tmptocode, r.roomkey, 'H', $tmpstartdate, $tmpenddate, '') AS status
    FROM toohotel h
    INNER JOIN toorooms r ON h.hotelkey = r.hotelkey and r.TOCODE=$tmptocode
    WHERE
    h.destinationcode = $tmpdestcode
    and h.hotelkey = r.hotelkey
    and h.TOCODE=r.TOCODE
    and r.normaloccupancy = 2
    and h.TOCODE=$tmptocode
    and r.TOCODE=$tmptocode
    )
    )
    SELECT
    xhotelkey as hotelkey
    ,hotelnamede as hotelname
    ,address1
    , address2
    , city
    , country
    , countryisocode as countrycode
    , destinationcode as code
    , toohotel.category
    , xroomkey as roomkey
    , roomtypede
    , descriptionde
    , mealdescriptionde
    , tourbomealcode as mealcode
    , maxadults
    , extrabedchildren
    , normaloccupancy
    , minimaloccupancy
    , maximaloccupancy
    , xprice as price
    , xalltomentcode as status
    FROM
    tmptble
    , toohotel
    , toorooms
    WHERE
    xprice > 0 
    AND xalltomentcode <> 'XX' 
    AND toohotel.hotelkey = xhotelkey 
    AND toorooms.roomkey = xroomkey
    "
  
  END=$(date +%s)
  echo END=$END
  
  DURATION=$((END-START))
  
  echo ---------------------------------------------
  echo DURATION=$DURATION seconds
  echo TOCODE=$tmptocode
  echo DESTINATIONCODE=$tmpdestcode
  echo STARTDATE=$tmpstartdate
  echo ENDDATE=$tmpenddate
  echo ---------------------------------------------

done

WITH tempdatelist (seqdate,k) as
(
VALUES (DATE('2016-05-05'), 1)
UNION ALL
SELECT
  seqdate + 1 days
  ,k + 1
FROM
  tempdatelist
WHERE
  k < 1000
  AND seqdate + 1 days < DATE('2016-05-12')
)
,earlybookinglist1 (id,datefrom,effectivedatefrom,dateto,effectivedateto,percent,foralldays,fromday,today,seqdate,daterownr,ebrownr) as
(
SELECT
  id
  ,datefrom
  ,( case when datefrom < DATE('2016-05-05') then DATE('2016-05-05') else datefrom end ) as effectivedatefrom
  ,dateto
  ,( case when dateto > DATE('2016-05-11') then DATE('2016-05-11') else dateto end ) as effectivedateto
  ,coalesce(percent,0) as percent
  ,coalesce(foralldays,0) as foralldays
  ,fromday
  ,today
  ,seqdate
  ,ROW_NUMBER() OVER (PARTITION BY id ORDER BY id ASC, seqdate ASC) as daterownr
  ,RANK() OVER (PARTITION BY id ORDER BY percent DESC, today DESC, id ASC) as ebrownr
FROM
  tooearlybookings
  ,tempdatelist
WHERE
  roomkey = 'TUIXYA194584'
  AND tocode = 'IMHO'
  AND percent <> 0
  AND fromday <= 7
  AND
  (
    (
      daysbeforedeparturefrom = 0
      AND daysbeforedepartureto = 0
      AND current date BETWEEN datebeforedeparturefrom AND datebeforedepartureto
    )
    or
    (
      -- ( daysbeforedeparturefrom <> 0 OR daysbeforedepartureto <> 0 )
      daysbeforedeparturefrom + daysbeforedepartureto > 0
      AND current date BETWEEN DATE('2016-05-05') - daysbeforedeparturefrom days and DATE('2016-05-05') - daysbeforedepartureto days
    )
  )
  AND
  (
    (
      (
        (DATE('2016-05-05') BETWEEN datefrom AND dateto AND DATE('2016-05-11') BETWEEN datefrom AND dateto)
        OR (datefrom BETWEEN DATE('2016-05-05') AND DATE('2016-05-11') AND dateto BETWEEN DATE('2016-05-05') AND DATE('2016-05-12') - 1 DAY)
        OR (DATE('2016-05-05') BETWEEN datefrom AND dateto AND DATE('2016-05-11') > dateto)
        OR (DATE('2016-05-11') BETWEEN datefrom AND dateto AND DATE('2016-05-05') < datefrom)
      )
      AND startdaterelevant = 0
      AND enddaterelevant = 0
    )
    OR (datefrom <= DATE('2016-05-05') AND dateto >= DATE('2016-05-05') AND startdaterelevant = 1 AND enddaterelevant = 0)
    OR (datefrom <= DATE('2016-05-11') AND dateto >= DATE('2016-05-11') AND startdaterelevant = 0 AND enddaterelevant = 1)
    OR (datefrom <= DATE('2016-05-05') AND dateto >= DATE('2016-05-11') AND startdaterelevant = 1 AND enddaterelevant = 1)
  )
  AND SUBSTR(weekdaysvalid, DAYOFWEEK_ISO(DATE(seqdate)),1) = '1'
  AND
  (
    foralldays = 1
    OR
    (
      foralldays = 0
      AND fromday = 0
      AND today = 0
    )
    OR
    (
      foralldays = 0
      AND today <= DAYS( case when dateto > DATE('2016-05-11') then DATE('2016-05-11') else dateto end ) - DAYS( case when datefrom < DATE('2016-05-05') then DATE('2016-05-05') else datefrom end )
    )
  )
)
,earlybookinglist2 (id,datefrom,effectivedatefrom,dateto,effectivedateto,percent,foralldays,fromday,today,seqdate,total,type2) as
(
SELECT
  id
  ,datefrom
  ,effectivedatefrom
  ,dateto
  ,effectivedateto
  ,percent
  ,foralldays
  ,fromday
  ,today
  ,seqdate
  ,X.total
  ,x.type2
FROM
  earlybookinglist1
  ,TABLE( func_pricing3_tbl ('IMHO', 'TUIXYA194584', DATE('2016-05-05'), DATE('2016-05-12'), current date, 3 ) ) AS X
WHERE
  ebrownr = 1
  AND X.type1 in ('PDP','APDP','SO')
  AND X.fromdate = seqdate
  AND X.todate = seqdate
  AND X.notspecialrelevant = 0
  AND
  (
    foralldays = 1
    OR
    (
      foralldays = 0
      AND fromday = 0
      AND today = 0
    )
    OR
    (
      foralldays = 0
      AND daterownr BETWEEN fromday AND today
    )
  )
)
SELECT
  1
  ,SUM(coalesce(earlybookinglist2.total, 0) * coalesce(earlybookinglist2.percent, 0) / 100) as price
  ,SUM(coalesce(earlybookinglist2.total, 0) * coalesce(earlybookinglist2.percent, 0) / 100) as total
  ,'EB'
  ,earlybookinglist2.type2
  ,earlybookinglist2.seqdate
  ,earlybookinglist2.seqdate
  ,MAX(tooearlybookings.descid)
  ,MAX(tooearlybookings.p_seq)
FROM
  earlybookinglist2
  ,tooearlybookings
WHERE
  earlybookinglist2.id = tooearlybookings.id
GROUP BY
  earlybookinglist2.seqdate
  ,earlybookinglist2.type2
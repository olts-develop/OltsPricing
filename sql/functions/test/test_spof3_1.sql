WITH tempdatelist (seqdate,k) as
(
  SELECT
    DATE('2016-10-03')
    ,1
  FROM
    SYSIBM.sysdummy1
 
  UNION ALL

  SELECT
    seqdate + 1 DAYS
    ,k + 1
  FROM
    tempdatelist
  WHERE
    k < 1000
    AND k < 9
    AND seqdate + 1 DAYS < DATE('2016-10-03') + 9 DAYS
)
,tmpspecial (paynights,type,revolvinggroup,addamount,descid,daystring,days,id) as
(
SELECT
  paynights
  ,type
  ,revolvinggroup
  ,addamount
  ,descid
  ,daystring
  ,days
  ,id
FROM
  (
    SELECT
      ROW_NUMBER() OVER(ORDER BY so.days desc) AS rownumb
     ,so.paynights
     ,so.type
     ,so.revolvinggroup
     ,so.addamount
     ,so.descid
     ,so.daystring
     ,so.days
     ,so.id
    FROM
      toospecialoffers so
    WHERE
      so.roomkey = 'TUIXYA192344'
      AND so.tocode = 'IMHO'
      AND so.childchildnr <= 0
      AND (
        ( DATE('2016-10-03') + ( so.days - 1 ) DAYS >= so.datefrom
          AND ( DATE('2016-10-03') + ( so.days - 1 ) DAYS ) <= so.dateto
          AND so.startdaterelevant = 0
          AND so.enddaterelevant = 1
        )
        OR (
          DATE('2016-10-03') >= so.datefrom
          AND DATE('2016-10-03') <= so.dateto
          AND so.startdaterelevant = 1
          AND so.enddaterelevant = 0
        )
        OR (
          so.datefrom <= DATE('2016-10-03')
          AND so.datefrom <= ( DATE('2016-10-03') + ( so.days - 1 ) DAYS )
          AND so.dateto >= DATE('2016-10-03')
          AND so.dateto >= ( DATE('2016-10-03') + ( so.days - 1 ) DAYS )
          AND so.startdaterelevant = 1
          AND so.enddaterelevant = 1
        )
          OR (
            so.startdaterelevant = 0
            AND so.enddaterelevant = 0
            AND DATE('2016-10-03') + ( so.days - 1 ) DAYS <= so.lastspoffenddate
            AND DATE('2016-10-03') + ( so.days - 1 ) DAYS <= DATE('2016-10-03') + ( 9 - 1 ) DAYS
            AND (
              ( DATE('2016-10-03') + ( so.days - 1 ) DAYS <= so.dateto )
              OR (
                DATE('2016-10-03') + ( so.days - 1 ) DAYS <= so.lastspoffenddate
                AND DATE('2016-10-03') + ( so.days - 1 ) DAYS > so.dateto
              )
            )
            AND so.datefrom <= DATE('2016-10-03')
            AND DATE('2016-10-03') <= so.dateto
            AND so.days > 0
            AND so.days =
              Coalesce (
                (
                  SELECT
                    MIN(so2.days)
                  FROM   toospecialoffers so2
                  WHERE
                    so2.roomkey = so.roomkey
                    AND so2.tocode = so.tocode
                    AND DATE('2016-10-03') + ( so2.days - 1 ) DAYS > so2.dateto
                    AND DATE('2016-10-03') <= so2.dateto
                    AND DATE('2016-10-03') + ( so2.days - 1 ) DAYS < so2.lastspoffenddate
                    AND so2.days > 0
                    AND so2.days <= 9
                    AND so2.childchildnr = so.childchildnr
                    AND so2.startdaterelevant = 0
                    AND so2.enddaterelevant = 0
                    AND NOT EXISTS (
                      SELECT
                        so1.id
                      FROM
                        toospecialoffers so1
                      WHERE
                        so1.roomkey = so2.roomkey
                        AND so1.tocode = so2.tocode
                        AND DATE('2016-10-03') + ( so1.days - 1 ) DAYS = so1.dateto
                        AND DATE('2016-10-03') <= so1.dateto
                        AND so1.days <= 9
                        AND so1.childchildnr = so.childchildnr
                        AND so1.startdaterelevant = 0
                        AND so1.enddaterelevant = 0
                        AND so1.days > 0
                    )
                ),
                (
                  SELECT
                    MAX(so3.days)
                  FROM
                    toospecialoffers so3
                  WHERE
                    so3.roomkey = so.roomkey
                    AND so3.tocode = so.tocode
                    AND DATE('2016-10-03') + ( so3.days - 1 ) DAYS <= so3.dateto
                    AND DATE('2016-10-03') >= so3.datefrom
                    AND so3.days <= 9
                    AND so3.childchildnr = so.childchildnr
                    AND so3.startdaterelevant = 0
                    AND so3.enddaterelevant = 0
                    AND so3.days > 0
                )
                , -1
              )
          )
      )
      AND (
       (
         so.ruletype = 'Date' AND DATE('2015-07-13') BETWEEN so.datebeforedeparturefrom AND so.datebeforedepartureto
       )
       OR (
         so.ruletype = 'Nr'
         AND DATE('2015-07-13') BETWEEN DATE(DATE('2016-10-03') - so.daysbeforedeparturefrom DAYS) AND DATE(DATE('2016-10-03') - so.daysbeforedepartureto DAYS)
       )
       OR (
         so.ruletype = 'Always'
       )
      )
      AND so.days <= 9
    ORDER BY
      so.days desc
      ,so.todaybase desc
      ,so.datefrom asc
      ,so.dateto desc
  ) AS T
WHERE
  rownumb = 1
)
,tmpsplitlist (days,daystart,paynights,type,revolvinggroup,addamount,descid,id) as
(
SELECT
  CAST(CAST(t.elem as VARCHAR(20)) AS INTEGER) AS days
  ,(
    SELECT
      COALESCE(SUM(CAST(CAST(z.elem as VARCHAR(20)) AS INTEGER)), 0)
    FROM
      TABLE( elements2( daystring, ',' ) ) AS z( elem, index )
    WHERE
      z.index < t.index
  ) AS daystart
  ,paynights
  ,type
  ,revolvinggroup
  ,addamount
  ,descid
  ,id
FROM
  tmpspecial
  ,TABLE ( elements2( daystring, ',' ) ) AS t( elem, index )
)
,tmprulelist1 (startdate,enddate,days,daystart,paynights,type,addamount,revolvinggroup,descid,id) as
(
SELECT
  DATE('2016-10-03') + daystart DAYS AS startdate
  ,DATE('2016-10-03') + daystart DAYS + days DAYS - 1 DAY AS enddate
  ,days
  ,daystart
  ,paynights
  ,type
  ,revolvinggroup
  ,addamount
  ,descid
  ,id
FROM
  tmpsplitlist
)
,tmprulelist2 (seqdate,rownum,startdate,enddate,days,daystart,paynights,type,addamount,revolvinggroup,descid,id) as
(
SELECT
  seqdate
  ,ROW_NUMBER() OVER(PARTITION BY daystart ORDER BY seqdate) AS rownum
  ,startdate
  ,enddate
  ,days
  ,daystart
  ,paynights
  ,type
  ,revolvinggroup
  ,addamount
  ,descid
  ,id
FROM
  tmprulelist1
  ,tempdatelist
WHERE
  seqdate BETWEEN startdate AND enddate
)
,tmprulelist3 (seqdate,rownum,startdate,enddate,days,daystart,paynights,type,addamount,revolvinggroup,descid,id) as
(
SELECT
  seqdate
  ,ROW_NUMBER() OVER(PARTITION BY daystart ORDER BY seqdate) as rownum
  ,startdate
  ,enddate
  ,days
  ,daystart
  ,paynights
  ,type
  ,addamount
  ,revolvinggroup
  ,descid
  ,id
FROM
  tmprulelist2
WHERE
  rownum BETWEEN
      CASE WHEN TYPE = 'StartDays'
        THEN 1
      ELSE paynights + 1
      END
    AND
      CASE WHEN TYPE = 'StartDays'
      THEN days-paynights
      ELSE DAYS
      END
)
, tmppricelist1 (price,priceday,priceasc,pricedesc,dayasc,daydesc,pricedaystart) as
(
SELECT
  priceall.price
  ,priceall.fromdate as priceday
  ,RANK()
   OVER (
     PARTITION BY daystart
     ORDER BY price asc)  AS priceasc
  ,RANK()
   OVER (
     PARTITION BY daystart
     ORDER BY price desc) AS pricedesc
  ,RANK()
   OVER (
     PARTITION BY daystart
     ORDER BY priceall.fromdate asc)    AS dayasc
  ,RANK()
   OVER (
     PARTITION BY daystart
     ORDER BY priceall.fromdate desc)   AS daydesc
  ,daystart as pricedaystart
FROM
  tmprulelist1
  ,TABLE( func_all_tbl( 'IMHO', 'TUIXYA192344', DATE('2016-10-03'), DATE('2016-10-12'), 2 ) ) as priceall
WHERE
  priceall.fromdate >= tmprulelist1.startdate
  AND priceall.todate <= tmprulelist1.enddate
  AND priceall.type1 = 'PDP'
  AND priceall.childnr = 0
  AND priceall.notspecialrelevant = 0
)
, tmppricelist2 (price,priceday,priceasc,pricedesc,dayasc,daydesc,pricedaystart) as
(
SELECT
  MIN(price) AS price
  ,priceday
  ,MAX(priceasc) AS priceasc
  ,MAX(pricedesc) AS pricedesc
  ,MAX(dayasc) AS dayasc
  ,MAX(daydesc) AS daydesc
  ,MAX(pricedaystart) as pricedaystart
FROM
  tmppricelist1
GROUP BY
  priceday
)
, tmppricelist3 (seqdate,rownum,startdate,enddate,days,daystart,paynights,type,addamount,revolvinggroup,descid,special,id) as
(
SELECT
  seqdate
  ,rownum
  ,startdate
  ,enddate
  ,days
  ,daystart
  ,paynights
  ,type
  ,addamount
  ,revolvinggroup
  ,descid
  ,CASE
   WHEN TYPE = 'Average'
     THEN (
       SELECT
         ( SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1) )
       FROM
         tmppricelist2
       WHERE
         pricedaystart = daystart
     )
   WHEN TYPE = 'EndDays' OR TYPE = 'StartDays'
     THEN (
       SELECT
         ( SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1) )
       FROM
         tmppricelist2
       WHERE
         priceday = seqdate
     )
   WHEN TYPE = 'MinValue'
     THEN (
       SELECT
         ( SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1))
       FROM
         tmppricelist2
       WHERE
         pricedaystart = daystart
         AND rownum = priceasc
     )
   WHEN TYPE = 'MaxValue'
     THEN (
       SELECT
         ( SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1))
       FROM
         tmppricelist2
       WHERE
         pricedaystart = daystart
         AND rownum = pricedesc
     )
   ELSE 0
   END * -1 AS special
  ,id
FROM
  tmprulelist3
)
select
  tmppricelist3.seqdate
  ,coalesce(tmppricelist3.special, 0)
  ,coalesce(tmppricelist3.addamount, 0)
  ,so.DESCID
  ,0
  ,so.P_SEQ
from
  tmppricelist3
  ,toospecialoffers so
WHERE
  tmppricelist3.id = so.id
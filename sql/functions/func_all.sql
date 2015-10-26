
drop function func_all_tbl @

create function func_all_tbl
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_returndate DATE DEFAULT NULL
  ,p_adultnr INTEGER DEFAULT 0
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
    ,TYPE1 VARCHAR(20)
    ,TYPE2 VARCHAR(20)
    ,CHILDNR INTEGER
    ,FROMDATE DATE
    ,TODATE DATE
    ,NOTSPECIALRELEVANT INTEGER
    ,DESCID INTEGER
    ,P_SEQ VARCHAR(20)
  )
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC
  
  DECLARE returndateminus1 DATE;
  DECLARE startdate_iso_dayofweek INTEGER;
  DECLARE childage1 DECIMAL(10,4);
  DECLARE childage2 DECIMAL(10,4);
  DECLARE childage3 DECIMAL(10,4);
  DECLARE childage4 DECIMAL(10,4);
--  DECLARE childbirthdate1 DATE;
--  DECLARE childbirthdate2 DATE;
--  DECLARE childbirthdate3 DATE;
--  DECLARE childbirthdate4 DATE;
  
  SET returndateminus1 = p_returndate - 1 DAY;
  SET startdate_iso_dayofweek = DAYOFWEEK_ISO(p_startdate);
  SET childage1 = ( ( DAYS(p_startdate) - DAYS(p_childbirthdate1) ) / 365 );
  SET childage2 = ( ( DAYS(p_startdate) - DAYS(p_childbirthdate2) ) / 365 );
  SET childage3 = ( ( DAYS(p_startdate) - DAYS(p_childbirthdate3) ) / 365 );
  SET childage4 = ( ( DAYS(p_startdate) - DAYS(p_childbirthdate4) ) / 365 );
--  SET childbirthdate1 = p_childbirthdate1 ;
--  SET childbirthdate2 = p_childbirthdate2 ;
--  SET childbirthdate3 = p_childbirthdate3 ;
--  SET childbirthdate4 = p_childbirthdate4 ;
  
RETURN

with childtemptable (chdnr, chdnrstring, bd) AS
(
VALUES
   (1, '1', p_childbirthdate1)
  ,(2, '2', p_childbirthdate2)
  ,(3, '3', p_childbirthdate3 )
  ,(4, '4', p_childbirthdate4)
)

-- PerDayPrice: Start
SELECT
   p_adultnr
  ,price
  ,p_adultnr * price
  ,'PDP'
  ,'ADT'
  ,0
  ,day
  ,day
  ,notspecialrelevant
  ,descid
  ,p_seq
FROM
  tooperdayprice
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND day >= p_startdate
  AND day < p_returndate
  AND childidxnr = 0

UNION ALL

SELECT
   1
  ,price
  ,price
  ,'PDP'
  ,'CHD' || chdnrstring
  ,chdnr
  ,day
  ,day
  ,notspecialrelevant
  ,descid
  ,p_seq
FROM
  childtemptable
  ,tooperdayprice
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND day >= p_startdate
  AND day < p_returndate
  AND childidxnr = chdnr  
  AND agefrom <= (case chdnr when 1 then childage1 when 2 then childage2 when 3 then childage3 when 4 then childage4 else -1 end)
  AND ageto > (case chdnr when 1 then childage1 when 2 then childage2 when 3 then childage3 when 4 then childage4 else -1 end)
  AND bd IS NOT NULL

-- PerDayPrice: End

UNION ALL

-- AddPerDayPrice: Start
SELECT
   p_adultnr
  ,price
  ,p_adultnr * price
  ,'APDP'
  ,'ADT'
  ,0
  ,day
  ,day
  ,notspecialrelevant
  ,descid
  ,p_seq
FROM
  tooaddperdayprice
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND day >= p_startdate
  AND day < p_returndate
  AND childidxnr = 0

UNION ALL

SELECT
   1
  ,price
  ,price
  ,'APDP'
  ,'CHD' || chdnrstring
  ,chdnr
  ,day
  ,day
  ,notspecialrelevant
  ,descid
  ,p_seq
FROM
  childtemptable
  ,tooaddperdayprice
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND day >= p_startdate
  AND day < p_returndate
  AND childidxnr = chdnr
  AND agefrom <= (case chdnr when 1 then childage1 when 2 then childage2 when 3 then childage3 when 4 then childage4 else -1 end)
  AND ageto > (case chdnr when 1 then childage1 when 2 then childage2 when 3 then childage3 when 4 then childage4 else -1 end)
  AND bd IS NOT NULL

-- AddPerDayPrice: End

UNION ALL

-- OneTime: End
SELECT
   p_adultnr
  ,price
  ,p_adultnr * price
  ,'OT'
  ,'ADT'
  ,0
  ,p_startdate
  ,returndateminus1
  ,notspecialrelevant
  ,descid
  ,p_seq
FROM
  tooonetime
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND
  (
    (
      startdaterelevant = 0
      AND enddaterelevant = 0
      AND
      (
        ( p_startdate BETWEEN datefrom AND dateto AND returndateminus1 BETWEEN datefrom AND dateto )
        OR (datefrom BETWEEN p_startdate AND returndateminus1 AND dateto BETWEEN p_startdate AND returndateminus1)
        OR (p_startdate BETWEEN datefrom AND dateto AND returndateminus1 > dateto)
        OR (returndateminus1 BETWEEN datefrom AND dateto AND p_startdate < datefrom)
      )

    )
    OR ( datefrom <= p_startdate AND dateto >= p_startdate AND startdaterelevant = 1 AND enddaterelevant = 0 )
    OR ( datefrom <= returndateminus1 AND dateto >= returndateminus1 AND startdaterelevant = 0 AND enddaterelevant = 1 )
    OR ( datefrom <= p_startdate AND dateto >= returndateminus1 AND startdaterelevant = 1 AND enddaterelevant = 1 )
  )
  AND ( ( child = 0 AND baby = 0 ) OR (alwaysapply = 1) )
  AND substr(weekdaysvalid, startdate_iso_dayofweek, 1) = '1'

UNION ALL

SELECT
   1
  ,price
  ,price
  ,'OT'
  ,'CHD' || chdnrstring
  ,chdnr
  ,p_startdate
  ,returndateminus1
  ,notspecialrelevant
  ,descid
  ,p_seq
FROM
  childtemptable
  ,tooonetime
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND
  (
    (
      startdaterelevant = 0
      AND enddaterelevant = 0
      AND
      (
        ( p_startdate BETWEEN datefrom AND dateto AND returndateminus1 BETWEEN datefrom AND dateto )
        OR (datefrom BETWEEN p_startdate AND returndateminus1 AND dateto BETWEEN p_startdate AND returndateminus1)
        OR (p_startdate BETWEEN datefrom AND dateto AND returndateminus1 > dateto)
        OR (returndateminus1 BETWEEN datefrom AND dateto AND p_startdate < datefrom)
      )

    )
    OR ( datefrom <= p_startdate AND dateto >= p_startdate AND startdaterelevant = 1 AND enddaterelevant = 0 )
    OR ( datefrom <= returndateminus1 AND dateto >= returndateminus1 AND startdaterelevant = 0 AND enddaterelevant = 1 )
    OR ( datefrom <= p_startdate AND dateto >= returndateminus1 AND startdaterelevant = 1 AND enddaterelevant = 1 )
  )
--  AND substr(coalesce(NULLIF(NULLIF(weekdaysvalid,'0'),''),'1111111'), startdate_iso_dayofweek, 1) = '1'
  AND ( ( child = 1 AND baby = 0 ) OR (alwaysapply = 1) )
  AND substr(weekdaysvalid, startdate_iso_dayofweek, 1) = '1'
  AND agefrom <= (case chdnr when 1 then childage1 when 2 then childage2 when 3 then childage3 when 4 then childage4 else -1 end)
  AND ageto > (case chdnr when 1 then childage1 when 2 then childage2 when 3 then childage3 when 4 then childage4 else -1 end)
  AND bd IS NOT NULL

;
END
@

drop function func_all @

create function func_all
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_returndate DATE DEFAULT NULL
  ,p_adultnr INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
)
RETURNS
  DECIMAL(10,2)
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

select coalesce(sum(x.TOTAL),0) from
TABLE(
  func_all_tbl
  (
    p_tocode
    ,p_itemkey
    ,p_itemtype
    ,p_startdate
    ,p_returndate
    ,p_adultnr
    ,p_childbirthdate1
    ,p_childbirthdate2
    ,p_childbirthdate3
    ,p_childbirthdate4
  )
) as x
;
END
@


--
-- SELECT X.*, DB2ADMIN.TOODESCRIPTIONS.DESCDE
--   FROM TABLE (FUNC_ALL_TBL('STOH', 'STOGVA10401', 'H', CAST ('2015-09-03' AS DATE),
--     CAST ('2015-09-21' AS DATE), 2)) AS X, DB2ADMIN.TOODESCRIPTIONS
--   WHERE X.DESCID = DB2ADMIN.TOODESCRIPTIONS.DESCID
--     AND DB2ADMIN.TOODESCRIPTIONS.TOCODE = 'STOH'
--     AND DB2ADMIN.TOODESCRIPTIONS.ITEMKEY = 'STOGVA10401'
--

-- SELECT
--    X.*
--   ,TOODESCRIPTIONS.DESCDE
-- FROM
--   TABLE (FUNC_ALL_TBL('IMHO', 'TUIXYA192344', 'H', CAST ('2016-10-03' AS DATE), CAST ('2016-10-12' AS DATE), 2)) AS X
--   ,TOODESCRIPTIONS
-- WHERE
--   X.DESCID = TOODESCRIPTIONS.DESCID
--   AND TOODESCRIPTIONS.TOCODE = 'IMHO'
--   AND TOODESCRIPTIONS.ITEMKEY = 'TUIXYA192344'




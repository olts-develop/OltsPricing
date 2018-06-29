-- -----------------------------------------------------------------------------
-- SpecialOffer
-- -----------------------------------------------------------------------------

drop function func_spof3_tbl @

--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
CREATE FUNCTION func_spof3_tbl (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE -- start of booking period
  ,p_returndate DATE -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  SEQDATE DATE
  ,SPECIAL DECIMAL(10, 2)
  ,ADDAMOUNT DECIMAL(10, 2)
  ,DESCID INTEGER
  ,CHILDCHILDNR INTEGER
  ,P_SEQ VARCHAR(20)
  ,PRICETYPE VARCHAR(10)
  ) NOT DETERMINISTIC LANGUAGE SQL
BEGIN
  ATOMIC
  DECLARE daysbetweenstartend INTEGER;
  DECLARE returndateminus1 DATE;
  DECLARE startdate_iso_dayofweek INTEGER;
  --  DECLARE childbirthdate1 DATE;
  --  DECLARE childbirthdate2 DATE;
  --  DECLARE childbirthdate3 DATE;
  --  DECLARE childbirthdate4 DATE;
  DECLARE nrchildren INTEGER;
  SET daysbetweenstartend = (DAYS(p_returndate) - DAYS(p_startdate));
  SET returndateminus1 = p_returndate - 1 DAY;
  SET startdate_iso_dayofweek = DAYOFWEEK_ISO(p_startdate);
  --  SET childbirthdate1 = p_childbirthdate1 ;
  --  SET childbirthdate2 = p_childbirthdate2 ;
  --  SET childbirthdate3 = p_childbirthdate3 ;
  --  SET childbirthdate4 = p_childbirthdate4 ;
  SET nrchildren = 0;
  IF p_childbirthdate1 IS NOT NULL THEN
    SET nrchildren = nrchildren + 1;
  END IF ;
  IF p_childbirthdate2 IS NOT NULL THEN
    SET nrchildren = nrchildren + 1;
  END IF ;
  IF p_childbirthdate3 IS NOT NULL THEN
    SET nrchildren = nrchildren + 1;
  END IF ;
  IF p_childbirthdate4 IS NOT NULL THEN
    SET nrchildren = nrchildren + 1;
  END IF ;
  
  RETURN
  
  WITH tempdatelist(seqdate, k) AS (
      SELECT p_startdate
        ,1
      FROM SYSIBM.sysdummy1
      
      UNION ALL
      
      SELECT seqdate + 1 DAYS
        ,k + 1
      FROM tempdatelist
      WHERE k < 1000
        AND k < daysbetweenstartend
      )
    ,tmpspecial(paynights, type, revolvinggroup, addamount, descid, daystring, days, id, childchildnr, startoffset) AS (
      -- Finde den besten passenden Special für dieses Datum und die angegebene Duration.
      -- PAYNIGHTS TYPE      REVOLVINGGROUP ADDAMOUNT DESCID DAYSTRING DAYS ID
      -- --------- --------- -------------- --------- ------ --------- ---- --
      --         3 StartDays              6      0.00      7 4,4          8 41
      -- Falls mehrere gefunden werden, den grössten nehmen der passen könnte.
      SELECT paynights
        ,type
        ,revolvinggroup
        ,addamount
        ,descid
        ,daystring
        ,days
        ,id
        ,childchildnr
        ,startoffset        
      FROM (
        SELECT ROW_NUMBER() OVER (
            PARTITION BY so.childchildnr ORDER BY so.days DESC
            ) AS rownumb
          ,so.paynights
          ,so.type
          ,so.revolvinggroup
          ,so.addamount
          ,so.descid
          ,so.daystring
          ,so.days
          ,so.id
          ,so.childchildnr
          ,(CASE WHEN so.startdaterelevant = 1 AND p_startdate < so.datefrom THEN DAYS(so.datefrom) - DAYS(p_startdate) ELSE 0 END ) as startoffset
        FROM toospecialoffers so
        WHERE (
            so.itemkey
            ,so.tocode
            ,so.itemtype
            ,so.currency
            ) = (
            p_itemkey
            ,p_tocode
            ,p_itemtype
            ,p_currency
            )
          AND so.childchildnr <= nrchildren
          AND (
            (
              p_startdate + (so.days - 1) DAYS >= so.datefrom
              AND (p_startdate + (so.days - 1) DAYS) <= so.dateto
              AND so.startdaterelevant = 0
              AND so.enddaterelevant = 1
              )
            OR (
              so.datefrom >= p_startdate
              AND p_startdate <= so.dateto
              AND p_returndate > so.datefrom
              AND so.startdaterelevant = 1
              AND so.enddaterelevant = 0
              )
            OR (
              so.datefrom >= p_startdate
              AND p_returndate > so.datefrom
              AND so.datefrom <= (p_startdate + (so.days - 1) DAYS)
              AND so.dateto >= p_startdate
              AND so.dateto >= (p_startdate + (so.days - 1) DAYS)
              AND so.startdaterelevant = 1
              AND so.enddaterelevant = 1
              )
            OR (
              so.startdaterelevant = 0
              AND so.enddaterelevant = 0
              AND p_startdate + (so.days - 1) DAYS <= so.lastspoffenddate
              AND p_startdate + (so.days - 1) DAYS <= p_startdate + (daysbetweenstartend - 1) DAYS
              AND (
                (p_startdate + (so.days - 1) DAYS <= so.dateto)
                OR (
                  p_startdate + (so.days - 1) DAYS <= so.lastspoffenddate
                  AND p_startdate + (so.days - 1) DAYS > so.dateto
                  )
                )
              AND so.datefrom <= p_startdate
              AND p_startdate <= so.dateto
              AND so.days > 0
              AND so.days = Coalesce((
                  SELECT MIN(so2.days)
                  FROM toospecialoffers so2
                  WHERE (
                      so2.itemkey
                      ,so2.tocode
                      ,so2.itemtype
                      ,so2.currency
                      ) = (
                      p_itemkey
                      ,p_tocode
                      ,p_itemtype
                      ,p_currency
                      )
                    AND p_startdate + (so2.days - 1) DAYS > so2.dateto
                    AND p_startdate <= so2.dateto
                    AND p_startdate + (so2.days - 1) DAYS < so2.lastspoffenddate
                    AND so2.days > 0
                    AND so2.days <= daysbetweenstartend
                    AND so2.childchildnr = so.childchildnr
                    AND so2.startdaterelevant = 0
                    AND so2.enddaterelevant = 0
                    AND NOT EXISTS (
                      SELECT so1.id
                      FROM toospecialoffers so1
                      WHERE (
                          so1.itemkey
                          ,so1.tocode
                          ,so1.itemtype
                          ,so1.currency
                          ) = (
                          p_itemkey
                          ,p_tocode
                          ,p_itemtype
                          ,p_currency
                          )
                        AND p_startdate + (so1.days - 1) DAYS = so1.dateto
                        AND p_startdate <= so1.dateto
                        AND so1.days <= daysbetweenstartend
                        AND so1.childchildnr = so.childchildnr
                        AND so1.startdaterelevant = 0
                        AND so1.enddaterelevant = 0
                        AND so1.days > 0
                      )
                  ), (
                  SELECT MAX(so3.days)
                  FROM toospecialoffers so3
                  WHERE (
                      so3.itemkey
                      ,so3.tocode
                      ,so3.itemtype
                      ,so3.currency
                      ) = (
                      p_itemkey
                      ,p_tocode
                      ,p_itemtype
                      ,p_currency
                      )
                    AND p_startdate + (so3.days - 1) DAYS <= so3.dateto
                    AND p_startdate >= so3.datefrom
                    AND so3.days <= daysbetweenstartend
                    AND so3.childchildnr = so.childchildnr
                    AND so3.startdaterelevant = 0
                    AND so3.enddaterelevant = 0
                    AND so3.days > 0
                  ), - 1)
              )
            )
          AND (
            (
              so.ruletype = 'Date'
              AND p_currentdate BETWEEN so.datebeforedeparturefrom
                AND so.datebeforedepartureto
              )
            OR (
              so.ruletype = 'Nr'
              AND p_currentdate BETWEEN DATE (p_startdate - so.daysbeforedeparturefrom DAYS)
                AND DATE (p_startdate - so.daysbeforedepartureto DAYS)
              )
            OR (so.ruletype = 'Always')
            )
          AND so.days <= daysbetweenstartend
        ORDER BY so.days DESC
          ,so.todaybase DESC
          ,so.datefrom ASC
          ,so.dateto DESC
        ) AS T
      WHERE rownumb = 1
      )
    ,tmpsplitlist(days, daystart, paynights, type, revolvinggroup, addamount, descid, id, childchildnr, startoffset) AS (
      -- Wenn ein Special 8 Days mit dem DayString 4,4 gefunden wird, geht es hier
      -- darum aus der einen Regel 8 eine Liste mit zwei Zeilen zu machen
      -- Vorher:
      -- DAYS=8 DAYSTRING=4,4 PAYNIGHTS=3
      -- Nachher:
      -- DAYS DAYSTART PAYNIGHTS TYPE      REVOLVINGGROUP ADDAMOUNT DESCID ID
      -- ---- -------- --------- --------- -------------- --------- ------ --
      --    4        0         3 StartDays              6      0.00      7 41
      --    4        4         3 StartDays              6      0.00      7 41
      -- DAYSTART sagt hier einfach aus an welchem Tag in Relation zu meinem StartDate
      -- der erste Tag ist ab dem die DAYS gesucht werden sollen.
      SELECT CAST(CAST(t.elem AS VARCHAR(20)) AS INTEGER) AS days
        ,(
          SELECT COALESCE(SUM(CAST(CAST(z.elem AS VARCHAR(20)) AS INTEGER)), 0)
          FROM TABLE (elements2(daystring, ',')) AS z(elem, INDEX)
          WHERE z.INDEX < t.INDEX
          ) AS daystart
        ,paynights
        ,type
        ,revolvinggroup
        ,addamount
        ,descid
        ,id
        ,childchildnr
        ,startoffset
      FROM tmpspecial
        ,TABLE (elements2(daystring, ',')) AS t(elem, INDEX)
      )
    ,tmprulelist1(startdate, enddate, days, daystart, paynights, type, addamount, revolvinggroup, descid, id, childchildnr) AS (
      -- Mit der folgenden Liste
      -- DAYS=4, DAYSTART=0, PAYNIGHTS=3
      -- DAYS=4, DAYSTART=4, PAYNIGHTS=3
      -- geht es jetzt darum, den Anfangs- und End-Tag des jeweiligen Specials zu bestimmen.
      -- Wenn mein Startdatum = 2016-05-13 ist, dann muss die Nachher-Liste wie folgt aussehen:
      -- STARTDATE  ENDDATE    DAYS DAYSTART PAYNIGHTS TYPE      REVOLVINGGROUP ADDAMOUNT DESCID ID
      -- ---------- ---------- ---- -------- --------- --------- -------------- --------- ------ --
      -- 2016-05-13 2016-05-16    4        0         3 StartDays              6      0.00      7 41
      -- 2016-05-17 2016-05-20    4        4         3 StartDays              6      0.00      7 41
      -- So wissen wir wann der erste Tag des Specials ist und wann der letzte, damit die Tage
      -- dazwischen mit den Tagespreisen später verknüpft werden können.
      SELECT p_startdate + daystart DAYS + startoffset DAYS AS startdate
        ,p_startdate + daystart DAYS + days DAYS - 1 DAY + startoffset DAYS AS enddate
        ,days
        ,daystart
        ,paynights
        ,type
        ,revolvinggroup
        ,addamount
        ,descid
        ,id
        ,childchildnr
      FROM tmpsplitlist
      )
    ,tmprulelist2(seqdate, rownum, startdate, enddate, days, daystart, paynights, type, addamount, revolvinggroup, descid, id, childchildnr) AS (
      -- Jetzt müssen wir pro Tag einen Datensatz erstellen für alle Tage im Special-relevanten Zeitraum.
      -- Aus der Tabelle
      -- STARTDATE=2016-05-13 ENDDATE= 2016-05-16 DAYS=4, DAYSTART=0, PAYNIGHTS=3
      -- STARTDATE=2016-05-17 ENDDATE= 2016-05-20 DAYS=4, DAYSTART=4, PAYNIGHTS=3
      -- muss folgendes erstellt werden.
      -- SEQDATE    ROWNUM STARTDATE  ENDDATE    DAYS DAYSTART PAYNIGHTS TYPE      REVOLVINGGROUP ADDAMOUNT DESCID ID
      -- ---------- ------ ---------- ---------- ---- -------- --------- --------- -------------- --------- ------ --
      -- 2016-05-13      1 2016-05-13 2016-05-16    4        0         3 StartDays           0.00         6      7 41
      -- 2016-05-14      2 2016-05-13 2016-05-16    4        0         3 StartDays           0.00         6      7 41
      -- 2016-05-15      3 2016-05-13 2016-05-16    4        0         3 StartDays           0.00         6      7 41
      -- 2016-05-16      4 2016-05-13 2016-05-16    4        0         3 StartDays           0.00         6      7 41
      -- 2016-05-17      1 2016-05-17 2016-05-20    4        4         3 StartDays           0.00         6      7 41
      -- 2016-05-18      2 2016-05-17 2016-05-20    4        4         3 StartDays           0.00         6      7 41
      -- 2016-05-19      3 2016-05-17 2016-05-20    4        4         3 StartDays           0.00         6      7 41
      -- 2016-05-20      4 2016-05-17 2016-05-20    4        4         3 StartDays           0.00         6      7 41
      -- Mit dieser Liste haben wir alle Daten die benötigt werden um die SpecialTage rauszusuchen.
      SELECT seqdate
        ,ROW_NUMBER() OVER (
          PARTITION BY childchildnr
          ,daystart ORDER BY seqdate
          ) AS rownum
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
        ,childchildnr
      FROM tmprulelist1
        ,tempdatelist
      WHERE seqdate BETWEEN startdate
          AND enddate
      )
    ,tmprulelist3(seqdate, rownum, startdate, enddate, days, daystart, paynights, type, addamount, revolvinggroup, descid, id, childchildnr) AS (
      -- Hier geht es darum aus der Liste der Tage die rauszusuchen welche für den Special
      -- genutzt werden sollen. Eigentlich ist dies nur bei StartDays und EndDays überhaupt
      -- wichtig, aber es schadet in den anderen Fällen nicht (MinAmount, MaxAmount und Average)
      -- wenn zu jedem SpecialTag ein spezifisches Datum angegeben wird. Per Default werden
      -- bei StartDays die Anfangstage genommen die als Special gelten, und in allen anderen
      -- Fällen werden die letzten Tage aus der Tagesliste genommen die als Special in Frage
      -- kommen.
      -- SEQDATE    ROWNUM STARTDATE  ENDDATE    DAYS DAYSTART PAYNIGHTS TYPE      ADDAMOUNT REVOLVINGGROUP DESCID ID
      -- ---------- ------ ---------- ---------- ---- -------- --------- --------- --------- -------------- ------ --
      -- 2016-05-13      1 2016-05-13 2016-05-16    4        0         3 StartDays      0.00              6      7 41
      -- 2016-05-17      1 2016-05-17 2016-05-20    4        4         3 StartDays      0.00              6      7 41
      SELECT seqdate
        ,ROW_NUMBER() OVER (
          PARTITION BY childchildnr
          ,daystart ORDER BY seqdate
          ) AS rownum
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
        ,childchildnr
      FROM tmprulelist2
      WHERE rownum BETWEEN CASE 
              WHEN TYPE = 'StartDays'
                THEN 1
              ELSE paynights + 1
              END
          AND CASE 
              WHEN TYPE = 'StartDays'
                THEN days - paynights
              ELSE DAYS
              END
      )
    ,tmppricelist1(price, priceday, priceasc, pricedesc, dayasc, daydesc, pricedaystart, childchildnr) AS (
      -- Brauche eine Liste der Tagespreise pro Tag, und dann spalten die mir sagen
      -- was ist der kleinste Preis, grösste Preis, erste Tage, letzte Tage, und diese
      -- nummeriert, damit ich später nur die aus der Liste picken kann die für meine
      -- Type-Regel relevant sind. Average wird hier bewusst nicht berücksichtigt, nur
      -- StartDays, EndDays, MinAmount und MaxAmount.
      -- Wichtig: hier wird RANK anstatt ROW_NUMBER genutzt, weil es den unwahrscheinlichen
      -- Fall geben könnte, dass es an einem Tag mehr als ein Preis gibt, und alle Preise
      -- eines Tages sollen die gleiche RANK Nummer erhalten.
      -- PRICE  PRICEDAY   PRICEASC PRICEDESC DAYASC DAYDESC PRICEDAYSTART
      -- ------ ---------- -------- --------- ------ ------- -------------
      -- 516.00 2016-05-16        4         1      4       1             0
      -- 515.00 2016-05-15        3         2      3       2             0
      -- 514.00 2016-05-14        2         3      2       3             0
      -- 513.00 2016-05-13        1         4      1       4             0
      -- 520.00 2016-05-20        4         1      4       1             4
      -- 519.00 2016-05-19        3         2      3       2             4
      -- 518.00 2016-05-18        2         3      2       3             4
      -- 517.00 2016-05-17        1         4      1       4             4
      SELECT priceall.price
        ,priceall.fromdate AS priceday
        ,ROW_NUMBER() OVER (
          PARTITION BY childchildnr
          ,daystart ORDER BY price ASC
            ,priceall.fromdate DESC
          ) AS priceasc
        ,ROW_NUMBER() OVER (
          PARTITION BY childchildnr
          ,daystart ORDER BY price DESC
            ,priceall.fromdate DESC
          ) AS pricedesc
        ,RANK() OVER (
          PARTITION BY childchildnr
          ,daystart ORDER BY priceall.fromdate ASC
          ) AS dayasc
        ,RANK() OVER (
          PARTITION BY childchildnr
          ,daystart ORDER BY priceall.fromdate DESC
          ) AS daydesc
        ,daystart AS pricedaystart
        ,childchildnr
      FROM tmprulelist1
        ,TABLE (func_all_pdp_tbl(p_tocode, p_itemkey, p_itemtype, p_startdate, p_returndate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS priceall
      WHERE priceall.fromdate >= tmprulelist1.startdate
        AND priceall.todate <= tmprulelist1.enddate
        AND priceall.type1 = 'PDP'
        AND priceall.childnr = tmprulelist1.childchildnr
        AND priceall.notspecialrelevant = 0
      )
    ,tmppricelist2(price, priceday, priceasc, pricedesc, dayasc, daydesc, pricedaystart, childchildnr) AS (
      -- Es könnte ja ganz blöd kommen, und es gibt für einen Tag mehrere Tagespreise.
      -- Nimm einfach den niedrigsten Tagespreis an dem Tag. Es sollte aber eigentlich
      -- pro Tag pro Person immer nur ein Tagespreis geben, aber wir wollen ja im
      -- blödesten Fall nicht einem Kunden zu viel vom zu zahlenden Betrag abziehen
      -- PRICE  PRICEDAY   PRICEASC PRICEDESC DAYASC DAYDESC PRICEDAYSTART
      -- ------ ---------- -------- --------- ------ ------- -------------
      -- 513.00 2016-05-13        1         4      1       4             0
      -- 514.00 2016-05-14        2         3      2       3             0
      -- 515.00 2016-05-15        3         2      3       2             0
      -- 516.00 2016-05-16        4         1      4       1             0
      -- 517.00 2016-05-17        1         4      1       4             4
      -- 518.00 2016-05-18        2         3      2       3             4
      -- 519.00 2016-05-19        3         2      3       2             4
      -- 520.00 2016-05-20        4         1      4       1             4
      SELECT MIN(price) AS price
        ,priceday
        ,MAX(priceasc) AS priceasc
        ,MAX(pricedesc) AS pricedesc
        ,MAX(dayasc) AS dayasc
        ,MAX(daydesc) AS daydesc
        ,MAX(pricedaystart) AS pricedaystart
        ,childchildnr
      FROM tmppricelist1
      GROUP BY childchildnr
        ,priceday
      )
    ,tmppricelist3(seqdate, rownum, startdate, enddate, days, daystart, paynights, type, addamount, revolvinggroup, descid, special, id, childchildnr) AS (
      -- Liefere eine Liste zurück der effektiven Tage die als Special von den Tagespreisen abgezogen werden sollen
      -- In der Liste soll der Special-Betrag, AddAmount und Gültigkeitstag unter anderem angegeben werden.
      -- SEQDATE    ROWNUM STARTDATE  ENDDATE    DAYS DAYSTART PAYNIGHTS TYPE      ADDAMOUNT REVOLVINGGROUP DESCID SPECIAL ID
      -- ---------- ------ ---------- ---------- ---- -------- --------- --------- --------- -------------- ------ ------- --
      -- 2016-05-13      1 2016-05-13 2016-05-16    4        0         3 StartDays      0.00              6      7 -513.00 41
      -- 2016-05-17      1 2016-05-17 2016-05-20    4        4         3 StartDays      0.00              6      7 -517.00 41
      SELECT seqdate
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
                SELECT (SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1))
                FROM tmppricelist2
                WHERE pricedaystart = daystart
                  AND tmppricelist2.childchildnr = tmprulelist3.childchildnr
                )
          WHEN TYPE = 'EndDays'
            OR TYPE = 'StartDays'
            THEN (
                SELECT (SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1))
                FROM tmppricelist2
                WHERE priceday = seqdate
                  AND tmppricelist2.childchildnr = tmprulelist3.childchildnr
                )
          WHEN TYPE = 'MinValue'
            THEN (
                SELECT (SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1))
                FROM tmppricelist2
                WHERE pricedaystart = daystart
                  AND rownum = priceasc
                  AND tmppricelist2.childchildnr = tmprulelist3.childchildnr
                )
          WHEN TYPE = 'MaxValue'
            THEN (
                SELECT (SUM(price) / COALESCE(NULLIF(COUNT(priceday), 0), 1))
                FROM tmppricelist2
                WHERE pricedaystart = daystart
                  AND rownum = pricedesc
                  AND tmppricelist2.childchildnr = tmprulelist3.childchildnr
                )
          ELSE 0
          END * - 1 AS special
        ,id
        ,childchildnr
      FROM tmprulelist3
      )
SELECT tmppricelist3.seqdate
  ,coalesce(tmppricelist3.special, 0)
  ,coalesce(tmppricelist3.addamount, 0)
  ,so.DESCID
  ,so.CHILDCHILDNR
  ,so.P_SEQ
  ,so.PRICETYPE
FROM tmppricelist3
  ,toospecialoffers so
WHERE tmppricelist3.id = so.id
  --ORDER BY
  --  startdate
  --  ,enddate
  --  ,seqdate
  ;
END
@


--
-- select
--   *
-- from
--   TABLE( func_spof_tbl( 'IMHO', 'TUIXYA225410', date('2016-05-13'), date('2016-05-26'), current date, 0, cast(NULL as DATE) ) ) as so
--
--  SEQDATE     STARTDATE   ENDDATE     DAYS  DAYSTART  PAYNIGHTS  TYPE       SPECIAL  ADDAMOUNT  ID  HOTELKEY     ROOMKEY       CURRENCY  DATEFROM    DATETO      FROMDAYBASE  TODAYBASE  DAYSBEFOREDEPARTUREFROM  DAYSBEFOREDEPARTURETO  DATEBEFOREDEPARTUREFROM  DATEBEFOREDEPARTURETO  REVOLVINGGROUP  STARTDATERELEVANT  ENDDATERELEVANT  DESCID  LASTSPOFFENDDATE  RULETYPE  DAYSTRING  BABY  CHILD  CHILDADULTNR  CHILDCHILDNR  SPECIALCOMMISSION
--  ----------  ----------  ----------  ----  --------  ---------  ---------  -------  ---------  --  -----------  ------------  --------  ----------  ----------  -----------  ---------  -----------------------  ---------------------  -----------------------  ---------------------  --------------  -----------------  ---------------  ------  ----------------  --------  ---------  ----  -----  ------------  ------------  -----------------
--  2016-05-13 2016-05-13 2016-05-16    4        0         3 StartDays -513.00      0.00 41 TUIXYA46628 TUIXYA225410 CHF      2016-05-12 2016-05-25           4         4                       0                     0 2000-01-01              2000-01-01                         6                 0               0      7 2016-06-09       Always   4,4          0     0            0            0             0.00
--  2016-05-17 2016-05-17 2016-05-20    4        4         3 StartDays -517.00      0.00 41 TUIXYA46628 TUIXYA225410 CHF      2016-05-12 2016-05-25           4         4                       0                     0 2000-01-01              2000-01-01                         6                 0               0      7 2016-06-09       Always   4,4          0     0            0            0             0.00
--

-- drop function func_spof3 @

-- create function func_spof3
-- (
--   p_tocode VARCHAR(5) DEFAULT ''
--   ,p_itemkey VARCHAR(20) DEFAULT ''
--   ,p_startdate DATE -- start of booking period
--   ,p_returndate DATE -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
--   ,p_currentdate DATE DEFAULT CURRENT DATE
--   ,p_childidxnr INTEGER DEFAULT 0 -- price for child number x . If 0, then this is the adult price and the birthdate can be ignored.
--   ,seqdate DATE DEFAULT NULL
-- )
-- RETURNS
--   DECIMAL (10,2)
-- NOT DETERMINISTIC
-- LANGUAGE SQL
-- BEGIN ATOMIC
--   RETURN
--     SELECT
--       sum(coalesce(special,0) + coalesce(addamount,0))
--     FROM
--       TABLE( func_spof_tbl( p_tocode, p_itemkey, p_startdate, p_returndate, coalesce(p_currentdate,current date), p_childidxnr, seqdate ) ) as so
-- ;
-- END @

--
-- select
--   func_spof( 'IMHO', 'TUIXYA225410', date('2016-05-13'), date('2016-05-26'), current date, 0, cast(NULL as date ) ) as total_so
-- from
--    sysibm.sysdummy1
--
--  TOTAL_SO
--  --------
--  -1030.00
--

-- SEQDATE DATE
-- ,SPECIAL DECIMAL(10,2)
-- ,ADDAMOUNT DECIMAL(10,2)
-- ,STARTDATE DATE
-- ,ENDDATE DATE
-- ,DAYS INTEGER
-- ,DAYSTART INTEGER
-- ,PAYNIGHTS INTEGER
-- ,TYPE VARCHAR(20)
-- ,ID INTEGER
-- ,HOTELKEY VARCHAR(20)
-- ,ROOMKEY VARCHAR(20)
-- ,CURRENCY VARCHAR(3)
-- ,DATEFROM DATE
-- ,DATETO DATE
-- ,FROMDAYBASE INTEGER
-- ,TODAYBASE INTEGER
-- ,DAYSBEFOREDEPARTUREFROM INTEGER
-- ,DAYSBEFOREDEPARTURETO INTEGER
-- ,DATEBEFOREDEPARTUREFROM DATE
-- ,DATEBEFOREDEPARTURETO DATE
-- ,REVOLVINGGROUP INTEGER
-- ,STARTDATERELEVANT INTEGER
-- ,ENDDATERELEVANT INTEGER
-- ,DESCID INTEGER
-- ,LASTSPOFFENDDATE DATE
-- ,RULETYPE VARCHAR(20)
-- ,DAYSTRING VARCHAR(40)
-- ,BABY INTEGER
-- ,CHILD INTEGER
-- ,CHILDADULTNR INTEGER
-- ,CHILDCHILDNR INTEGER
-- ,SPECIALCOMMISSION DECIMAL(6,2)
-- ,P_SEQ VARCHAR(20)


-- ID
-- ,HOTELKEY
-- ,ROOMKEY
-- ,CURRENCY
-- ,DATEFROM
-- ,DATETO
-- ,FROMDAYBASE
-- ,TODAYBASE
-- ,DAYSBEFOREDEPARTUREFROM
-- ,DAYSBEFOREDEPARTURETO
-- ,DATEBEFOREDEPARTUREFROM
-- ,DATEBEFOREDEPARTURETO
-- ,PAYNIGHTS
-- ,TYPE
-- ,REVOLVINGGROUP
-- ,STARTDATERELEVANT
-- ,ENDDATERELEVANT
-- ,ADDAMOUNT
-- ,DESCID
-- ,WEEKDAYSVALID
-- ,LASTSPOFFENDDATE
-- ,RULETYPE
-- ,DAYSTRING
-- ,DAYS
-- ,BABY
-- ,CHILD
-- ,CHILDADULTNR
-- ,CHILDCHILDNR
-- ,SPECIALCOMMISSION
-- ,TOCODE


-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

-- BSP2: MRU-LUXGAU-D2-HB: Ok
-- SELECT
--    X.*
--   ,TOODESCRIPTIONS.DESCDE
-- FROM
--   TABLE (func_spof3_tbl('IMHO', 'TUIXYA192344', CAST ('2016-10-03' AS DATE), CAST ('2016-10-12' AS DATE), CURRENT DATE, 2)) AS X
--   ,TOODESCRIPTIONS
-- WHERE
--   X.DESCID = TOODESCRIPTIONS.DESCID
--   AND TOODESCRIPTIONS.TOCODE = 'IMHO'
--   AND TOODESCRIPTIONS.ROOMKEY = 'TUIXYA192344'
--
-- SEQDATE     SPECIAL  ADDAMOUNT  DESCID  CHILDCHILDNR  P_SEQ  DESCDE
-- ----------  -------  ---------  ------  ------------  -----  -------------------------------------------------------------------------------
-- 2016-10-08  -348.00       0.00       2             0   NULL  1 Gratisnacht pro Person (oblig. Halbpension berÃ¼cksichtigt) vom 1.11-31.10.14
-- 2016-10-09  -348.00       0.00       2             0   NULL  1 Gratisnacht pro Person (oblig. Halbpension berÃ¼cksichtigt) vom 1.11-31.10.14

-- -----------------------------------------------------------------------------
-- Pricing and Availability
-- -----------------------------------------------------------------------------

DROP FUNCTION func_arrpricebydest @

-- select * from TABLE( func_arrpricebydest ('', 'AGR', cast('2015-11-12' as DATE), cast('2015-11-12' as DATE), current date, 1 ) )

CREATE FUNCTION func_arrpricebydest (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_destcode VARCHAR(20) DEFAULT '???'
  ,p_startdate DATE DEFAULT NULL
  ,p_enddate DATE DEFAULT NULL
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  ,p_arrlang VARCHAR(2) DEFAULT 'DE'
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,ARRKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,ARRCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  RETURN

  SELECT p_tocode
    ,tooarrangement.arrkey
    ,func_arrpricing(p_tocode, tooarrangement.arrkey, p_startdate, p_enddate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency) AS pricetotal
    ,destinationcode
    ,arrcode
    ,arritemcode
    ,func_get_allotment2(p_tocode, tooarrangement.arrkey, 'A', p_startdate, x.ALLOTMENTENDDATE, p_currentdate)
  FROM tooarrangement
    ,TABLE (func_arrvalid(p_tocode, tooarrangement.arrkey, p_startdate, p_enddate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
  WHERE tooarrangement.tocode = p_tocode
    AND tooarrangement.destinationcode = p_destcode
    AND tooarrangement.arrlang = p_arrlang;
END
@

DROP FUNCTION func_arrpricebydest_ch @

-- select * from TABLE( func_arrpricebydest_ch ('', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
-- select * from TABLE( func_arrpricebydest_ch ('TOU', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_arrpricebydest_ch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_destcode VARCHAR(20) DEFAULT '???'
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_enddate VARCHAR(10) DEFAULT ''
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,ARRKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,ARRCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE startdate DATE;
  DECLARE enddate DATE;
  DECLARE currentdate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate, '') AS DATE);
  SET enddate = cast(nullif(p_enddate, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(p_currentdate, '') AS DATE), CURRENT DATE);
  SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);

  RETURN

  SELECT TOCODE
    ,ARRKEY
    ,TOTAL
    ,DESTINATIONCODE
    ,ARRCODE
    ,TOURBOCODE
    ,STATUS
  FROM TABLE (func_arrpricebydest(p_tocode, p_destcode, startdate, enddate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency));
END
@



DROP FUNCTION func_arrpriceav @

-- select * from TABLE( func_arrpriceav ('', cast('2015-11-12' as DATE), cast('2015-11-12' as DATE), current date, 1 ) )
CREATE FUNCTION func_arrpriceav (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_enddate DATE DEFAULT NULL
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,ARRKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,ARRCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  RETURN

  SELECT p_tocode
    ,tooarrangement.arrkey
    ,func_arrpricing(p_tocode, tooarrangement.arrkey, p_startdate, p_enddate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency) AS pricetotal
    ,destinationcode
    ,arrcode
    ,arritemcode
    ,func_get_allotment2(p_tocode, tooarrangement.arrkey, 'A', p_startdate, x.ALLOTMENTENDDATE, p_currentdate)
  FROM tooarrangement
    ,TABLE (func_arrvalid(p_tocode, tooarrangement.arrkey, p_startdate, p_enddate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
  WHERE tooarrangement.tocode = p_tocode;
END
@



DROP FUNCTION func_arrpriceav_ch @

-- select * from TABLE( func_arrpriceav_ch ('', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
-- select * from TABLE( func_arrpriceav_ch ('TSOL', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_arrpriceav_ch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_enddate VARCHAR(10) DEFAULT ''
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,ARRKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,ARRCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE startdate DATE;
  DECLARE enddate DATE;
  DECLARE currentdate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate, '') AS DATE);
  SET enddate = cast(nullif(p_enddate, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(p_currentdate, '') AS DATE), CURRENT DATE);
  SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);

  RETURN

  SELECT TOCODE
    ,ARRKEY
    ,TOTAL
    ,DESTINATIONCODE
    ,ARRCODE
    ,TOURBOCODE
    ,STATUS
  FROM TABLE (func_arrpriceav(p_tocode, startdate, enddate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency));
END
@



DROP FUNCTION func_arrpriceav2 @

-- The function func_arrpriceav2 imporves the performance of the search for misc availability and pricing dramatically.
-- It alos improves the interface that can be used to search for either a group of products, e.g. by destination,
-- or by a specific product.
--
-- Example usage:
-- select ARRKEY,TOTAL,STATUS from TABLE ( func_arrpriceav2( 'TSOL', 'BKK', '2017-05-01', '2017-05-01', 2, '', '', '', '', '', '',1, 0, 1, '','' ) );
-- This searches for all Misc products in BKK, ignoring all products with either a status XX or those without a price.
--
-- select ARRKEY,TOTAL,STATUS from TABLE ( func_arrpriceav2( '', '', '2017-04-01', '2017-04-01', 2, '', '', '', '', '', '',0, 0, 0, '','TOUWAL12828' ) );
-- This searches for a specific Misc product with the ARRKEY=TOUWAL12828. A result set is returned irrespective of the price or status.
--
-- If a search is for a specific product with a specific IN_ARRKEY, then it makes sense for the parameters
-- IN_IGNORE_XX=0
-- IN_IGNORE_RQ=0
-- IN_IGNORE_PRICE0=0
--
-- Setting these parameters only really makes sense when searching for products by destination.
--
-- Here an example of a more complex usage:
--   SELECT tooarrangement.ARRKEY AS ARRKEY
--     ,tooarrangement.SHORTTITLE AS SHORTTITLE
--     ,tooarrangement.REGION AS REGION
--     ,tooarrangement.SUBREGION AS SUBREGION
--     ,tooarrangement.COUNTRY AS COUNTRY
--     ,tooarrangement.COUNTRYISOCODE AS COUNTRYCODE
--     ,tooarrangement.DESTINATIONCODE AS DESTINATIONCODE
--     ,tooarrangement.ARRCODE AS ARRCODE
--     ,tooarrangement.ARRITEMCODE AS ARRITEMCODE
--     ,tooarrangement.INVTITLE AS INVTITLE
--     ,tooarrangement.INVTEXT AS INVTEXT
--     ,coalesce(x.TOTAL, 0) AS TOTAL
--     ,coalesce(x.STATUS, 'XX') AS STATUS
--   FROM tooarrangement
--   INNER JOIN TABLE (func_arrpriceav2('', 'AKY', '2017-04-01', '2017-04-01', 2, '', '', '', '', '', '', 1, 0, 1, '', '')) AS x ON x.ARRKEY = tooarrangement.ARRKEY
--   WHERE x.ARRKEY = tooarrangement.ARRKEY;
--
--
-- Here an example as used by the data center:
--
--   SELECT tooarrangement.ARRKEY                 AS hotelkey
--     ,tooarrangement.ARRCODE                    AS hotelcode
--     ,INV.TITLE                           AS hotelname
--     ,INV.DETAIL                          AS address1
--     ,''                                  AS address2
--     ,tooarrangement.SUBREGION                   AS city
--     ,tooarrangement.COUNTRY                     AS country
--     ,tooarrangement.COUNTRYISOCODE              AS countrycode
--     ,tooarrangement.DESTINATIONCODE             AS code
--     ,'4.0'                               AS category
--     ,tooarrangement.ARRKEY                     AS roomkey
--     ,tooarrangement.ARRCODE                    AS roomcode
--     ,'EX'                                AS roomtypede
--     ,ITIN.TITLE                          AS descriptionde
--     ,tooarrangement.MISCITEMCODE                AS mealdescriptionde
--     ,tooarrangement.MISCITEMCODE                AS mealcode
--     ,tooarrangement.MAXIMUMPERSONS              AS maxadults
--     ,0                                   AS extrabedchildren
--     ,tooarrangement.MINIMUMPERSONS              AS normaloccupancy
--     ,tooarrangement.MINIMUMPERSONS              AS minimaloccupancy
--     ,tooarrangement.MAXIMUMPERSONS              AS maximaloccupancy
--     ,cast(coalesce(x.TOTAL, 0) as FLOAT) AS price
--     ,coalesce(x.STATUS, 'XX')            AS STATUS
--   FROM tooarrangement
--   INNER JOIN TABLE (func_arrpriceav2('TSOL', 'BKK', '2017-05-01', '2017-05-01', 2, '', '', '', '', '', '', 1, 0, 1, '', '')) AS x ON x.ARRKEY = tooarrangement.ARRKEY
--   LEFT OUTER JOIN tooarrangementTEXT AS INV ON tooarrangement.ARRKEY = INV.ARRKEY
--     AND tooarrangement.TOCODE = INV.TOCODE
--     AND INV.type = 'INV'
--     AND INV.LANG = 'DE'
--   LEFT OUTER JOIN tooarrangementTEXT AS ITIN ON tooarrangement.ARRKEY = ITIN.ARRKEY
--     AND tooarrangement.TOCODE = ITIN.TOCODE
--     AND ITIN.type = 'ITIN'
--     AND ITIN.LANG = 'DE';
--
--
CREATE FUNCTION func_arrpriceav2 (
  IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN_DESTINATIONCODE VARCHAR(5) DEFAULT ''
  ,IN_PRICEDATEFROM VARCHAR(10)
  ,IN_PRICEDATETO VARCHAR(10)
  ,IN_NRADULTS INTEGER DEFAULT 2
  ,IN_ARRCODE VARCHAR(30) DEFAULT ''
  ,IN_ARRITEMCODE VARCHAR(20) DEFAULT ''
  ,IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN_ARRKEY VARCHAR(20) DEFAULT ''
  ,IN_CURRENCY VARCHAR(3) DEFAULT 'CHF'
  ,IN_ARRLANG VARCHAR (3) DEFAULT 'DE'
  )
RETURNS TABLE (
  TOCODE VARCHAR(5)
  ,ARRKEY VARCHAR(20)
  ,TOTAL FLOAT
  ,STATUS VARCHAR(2)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE startdate DATE;
  DECLARE enddate DATE;
  DECLARE currentdate DATE;
  DECLARE p_childbirthdate1 DATE;
  DECLARE p_childbirthdate2 DATE;
  DECLARE p_childbirthdate3 DATE;
  DECLARE p_childbirthdate4 DATE;

  SET startdate = cast(nullif(IN_PRICEDATEFROM, '') AS DATE);
  SET enddate = cast(nullif(IN_PRICEDATETO, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(IN_CURRENTDATE, '') AS DATE), CURRENT DATE);
  SET p_childbirthdate1 = cast(nullif(IN_CHDDOB1, '') AS DATE);
  SET p_childbirthdate2 = cast(nullif(IN_CHDDOB2, '') AS DATE);
  SET p_childbirthdate3 = cast(nullif(IN_CHDDOB3, '') AS DATE);
  SET p_childbirthdate4 = cast(nullif(IN_CHDDOB4, '') AS DATE);

  RETURN
  WITH tmptable1(ARRKEY, NRADULTS, CHDDOB1, CHDDOB2, CHDDOB3, CHDDOB4, PRICEENDDATE, ALLOTMENTENDDATE) AS (
      SELECT tooarrangement.ARRKEY
        ,x.NRADULTS
        ,x.CHILDBIRTHDATE1
        ,x.CHILDBIRTHDATE2
        ,x.CHILDBIRTHDATE3
        ,x.CHILDBIRTHDATE4
        ,x.PRICEENDDATE
        ,x.ALLOTMENTENDDATE
      FROM tooarrangement tooarrangement
        ,TABLE (func_arrvalid(IN_TOCODE, tooarrangement.ARRKEY, startdate, enddate, IN_NRADULTS, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, IN_CURRENCY)) AS x
      WHERE tooarrangement.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), tooarrangement.DESTINATIONCODE)
        AND tooarrangement.ARRCODE = coalesce(nullif(IN_ARRCODE, ''), tooarrangement.ARRCODE)
        AND tooarrangement.ARRITEMCODE = coalesce(nullif(IN_ARRITEMCODE, ''), tooarrangement.ARRITEMCODE)
        AND tooarrangement.ARRKEY = coalesce(nullif(IN_ARRKEY, ''), tooarrangement.ARRKEY)
        AND tooarrangement.ARRLANG = IN_ARRLANG
      )
    ,tmptable2(ARRKEY, NRADULTS, CHDDOB1, CHDDOB2, CHDDOB3, CHDDOB4, PRICEENDDATE, STATUS) AS (
      SELECT x.ARRKEY
        ,x.NRADULTS
        ,x.CHDDOB1
        ,x.CHDDOB2
        ,x.CHDDOB3
        ,x.CHDDOB4
        ,x.PRICEENDDATE
        ,(
          CASE 
            WHEN (
                coalesce(tooarrangement.PASSIVE, 0) = 0
                OR (
                  tooarrangement.PASSIVE = 1
                  AND coalesce(tooarrangement.PASSIVEFROMDATE, currentdate) > currentdate
                  )
                )
              THEN func_get_allotment2(IN_TOCODE, x.ARRKEY, 'A', enddate, x.ALLOTMENTENDDATE, currentdate)
            ELSE 'XX'
            END
          )
      FROM tmptable1 x
        ,tooarrangement tooarrangement
      WHERE tooarrangement.ARRKEY = x.ARRKEY
        AND tooarrangement.ARRLANG = IN_ARRLANG
      )
    ,tmptable3(ARRKEY, STATUS, TOTAL) AS (
      SELECT max(x.ARRKEY) AS ARRKEY
        ,max(x.STATUS) AS STATUS
        ,sum(cast(pricing.TOTAL AS FLOAT)) AS TOTAL
      FROM tmptable2 x
        ,TABLE (func_pricing2_tbl(IN_TOCODE, x.ARRKEY, 'A', startdate, x.PRICEENDDATE, currentdate, x.NRADULTS, x.CHDDOB1, x.CHDDOB2, x.CHDDOB3, x.CHDDOB4, IN_CURRENCY)) AS pricing
      GROUP BY x.ARRKEY
      )

  SELECT tooarrangement.TOCODE AS TOCODE
    ,tooarrangement.ARRKEY AS ARRKEY
    ,coalesce(x.TOTAL, 0) AS TOTAL
    ,coalesce(x.STATUS, 'XX') AS STATUS
  FROM tooarrangement
  LEFT OUTER JOIN tmptable3 x ON x.ARRKEY = tooarrangement.ARRKEY
  WHERE tooarrangement.TOCODE = IN_TOCODE
    AND tooarrangement.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), tooarrangement.DESTINATIONCODE)
    AND tooarrangement.ARRCODE = coalesce(nullif(IN_ARRCODE, ''), tooarrangement.ARRCODE)
    AND tooarrangement.ARRITEMCODE = coalesce(nullif(IN_ARRITEMCODE, ''), tooarrangement.ARRITEMCODE)
    AND tooarrangement.ARRKEY = coalesce(nullif(IN_ARRKEY, ''), tooarrangement.ARRKEY)
    AND tooarrangement.ARRLANG = IN_ARRLANG
    AND coalesce(x.STATUS, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_XX = 1
          THEN 'XX'
        ELSE '..'
        END
      )
    AND coalesce(x.STATUS, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_RQ = 1
          THEN 'RQ'
        ELSE '..'
        END
      )
    AND (
      (
        IN_IGNORE_PRICE0 = 1
        AND cast(x.TOTAL AS FLOAT) > 0
        )
      OR IN_IGNORE_PRICE0 = 0
      );
END
@



DROP FUNCTION func_arrpriceav2_tbl @

--   SELECT tooarrangement.TOCODE AS TOCODE
--     ,tooarrangement.ARRKEY AS ARRKEY
--     ,tooarrangement.DESTINATIONCODE AS DESTINATIONCODE
--     ,tooarrangement.ARRCODE AS ARRCODE
--     ,tooarrangement.MISCITEMCODE AS MISCITEMCODE
--     ,NR
--     ,PRICE
--     ,TOTAL
--     ,TYPE1
--     ,TYPE2
--     ,FROMDATE
--     ,TODATE
--     ,x.DESCID
--     ,P_SEQ
--     ,STATUS
--     ,TOODESCRIPTIONS.ID
--     ,DESCDE
--     ,DESCEN
--     ,DESCFR
--     ,DESCIT
--   FROM tooarrangement
--   INNER JOIN TABLE (func_arrpriceav2_tbl('', '', '2017-04-01', '2017-04-01', 3, '', '', '', '', '', '', 1, 0, 1, '', 'TOUWAL10010')) AS x ON x.TOCODE = tooarrangement.TOCODE
--     AND x.ARRKEY = tooarrangement.ARRKEY
--   LEFT OUTER JOIN TOODESCRIPTIONS ON TOODESCRIPTIONS.ITEMKEY = x.ARRKEY
--     AND ITEMTYPE = 'A'
--     AND TOODESCRIPTIONS.TOCODE = ''
--     AND TOODESCRIPTIONS.DESCID = x.DESCID
--   ORDER BY x.TOCODE
--     ,x.ARRKEY
--     ,(
--       CASE x.TYPE1
--         WHEN 'PP'
--           THEN 1
--         WHEN 'APP'
--           THEN 2
--         WHEN 'PDP'
--           THEN 3
--         WHEN 'APDP'
--           THEN 4
--         WHEN 'OT'
--           THEN 5
--         WHEN 'SO'
--           THEN 6
--         WHEN 'EB'
--           THEN 7
--         ELSE 8
--         END
--       ) ASC
--     ,x.TYPE2 ASC
--     ,x.FROMDATE ASC
--
-- TOCODE  ARRKEY      DESTINATIONCODE  ARRCODE  MISCITEMCODE  NR  PRICE  TOTAL  TYPE1  TYPE2  FROMDATE    TODATE      DESCID  P_SEQ     STATUS  ID       DESCDE                DESCEN               DESCFR                    DESCIT
--         TOUWAL10010  BKK              TRAABL    3             3   30.00  90.00  PDP    ADT    2017-04-01  2017-04-01  1       12040840  99      2173902  Preis pro Person/Weg  rate per person/way  prix par personne/trajet  rate per person/way


CREATE FUNCTION func_arrpriceav2_tbl (
  IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN_DESTINATIONCODE VARCHAR(5) DEFAULT ''
  ,IN_PRICEDATEFROM VARCHAR(10)
  ,IN_PRICEDATETO VARCHAR(10)
  ,IN_NRADULTS INTEGER DEFAULT 2
  ,IN_ARRCODE VARCHAR(30) DEFAULT ''
  ,IN_ARRITEMCODE VARCHAR(20) DEFAULT ''
  ,IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN_ARRKEY VARCHAR(20) DEFAULT ''
  ,IN_CURRENCY VARCHAR(3) DEFAULT 'CHF'
  ,IN_ARRLANG VARCHAR (3) DEFAULT 'DE'
  )
RETURNS TABLE (
  TOCODE VARCHAR(5)
  ,ARRKEY VARCHAR(20)
  ,NR INTEGER
  ,PRICE DECIMAL(10, 2)
  ,TOTAL DECIMAL(10, 2)
  ,TYPE1 VARCHAR(20)
  ,TYPE2 VARCHAR(20)
  ,FROMDATE DATE
  ,TODATE DATE
  ,DESCID INTEGER
  ,P_SEQ VARCHAR(20)
  ,STATUS VARCHAR(2)
  ,PRICETYPE VARCHAR(10)
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE startdate DATE;
  DECLARE enddate DATE;
  DECLARE currentdate DATE;
  DECLARE p_childbirthdate1 DATE;
  DECLARE p_childbirthdate2 DATE;
  DECLARE p_childbirthdate3 DATE;
  DECLARE p_childbirthdate4 DATE;

  SET startdate = cast(nullif(IN_PRICEDATEFROM, '') AS DATE);
  SET enddate = cast(nullif(IN_PRICEDATETO, '') AS DATE);
  SET currentdate = coalesce(cast(nullif(IN_CURRENTDATE, '') AS DATE), CURRENT DATE);
  SET p_childbirthdate1 = cast(nullif(IN_CHDDOB1, '') AS DATE);
  SET p_childbirthdate2 = cast(nullif(IN_CHDDOB2, '') AS DATE);
  SET p_childbirthdate3 = cast(nullif(IN_CHDDOB3, '') AS DATE);
  SET p_childbirthdate4 = cast(nullif(IN_CHDDOB4, '') AS DATE);

  RETURN
  WITH tmptable1(ARRKEY, NRADULTS, CHDDOB1, CHDDOB2, CHDDOB3, CHDDOB4, PRICEENDDATE, ALLOTMENTENDDATE) AS (
      SELECT tooarrangement.ARRKEY
        ,x.NRADULTS
        ,x.CHILDBIRTHDATE1
        ,x.CHILDBIRTHDATE2
        ,x.CHILDBIRTHDATE3
        ,x.CHILDBIRTHDATE4
        ,x.PRICEENDDATE
        ,x.ALLOTMENTENDDATE
      FROM tooarrangement tooarrangement
        ,TABLE (func_arrvalid(IN_TOCODE, tooarrangement.ARRKEY, startdate, enddate, IN_NRADULTS, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, IN_CURRENCY)) AS x
      WHERE tooarrangement.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), tooarrangement.DESTINATIONCODE)
        AND tooarrangement.ARRCODE = coalesce(nullif(IN_ARRCODE, ''), tooarrangement.ARRCODE)
        AND tooarrangement.ARRITEMCODE = coalesce(nullif(IN_ARRITEMCODE, ''), tooarrangement.ARRITEMCODE)
        AND tooarrangement.ARRKEY = coalesce(nullif(IN_ARRKEY, ''), tooarrangement.ARRKEY)
        AND tooarrangement.ARRLANG = IN_ARRLANG
      )
    ,tmptable2(ARRKEY, NRADULTS, CHDDOB1, CHDDOB2, CHDDOB3, CHDDOB4, PRICEENDDATE, STATUS) AS (
      SELECT x.ARRKEY
        ,x.NRADULTS
        ,x.CHDDOB1
        ,x.CHDDOB2
        ,x.CHDDOB3
        ,x.CHDDOB4
        ,x.PRICEENDDATE
        ,(
          CASE 
            WHEN (
                coalesce(tooarrangement.PASSIVE, 0) = 0
                OR (
                  tooarrangement.PASSIVE = 1
                  AND coalesce(tooarrangement.PASSIVEFROMDATE, currentdate) > currentdate
                  )
                )
              THEN func_get_allotment2(IN_TOCODE, x.ARRKEY, 'A', enddate, x.ALLOTMENTENDDATE, currentdate)
            ELSE 'XX'
            END
          )
      FROM tmptable1 x
        ,tooarrangement tooarrangement
      WHERE tooarrangement.ARRKEY = x.ARRKEY
        AND tooarrangement.ARRLANG = IN_ARRLANG
      )
    ,tmptable3(ARRKEY, STATUS, TOTAL) AS (
      SELECT max(x.ARRKEY) AS ARRKEY
        ,max(x.STATUS) AS STATUS
        ,sum(cast(pricing.TOTAL AS FLOAT)) AS TOTAL
      FROM tmptable2 x
        ,TABLE (func_pricing2_tbl(IN_TOCODE, x.ARRKEY, 'A', startdate, x.PRICEENDDATE, currentdate, x.NRADULTS, x.CHDDOB1, x.CHDDOB2, x.CHDDOB3, x.CHDDOB4, IN_CURRENCY)) AS pricing
      GROUP BY x.ARRKEY
      )
    ,tmptable4(ARRKEY, STATUS, NR, PRICE, TOTAL, TYPE1, TYPE2, FROMDATE, TODATE, DESCID, P_SEQ) AS (
      SELECT x.ARRKEY AS ARRKEY
        ,x.STATUS AS STATUS
        ,pricing.NR AS NR
        ,pricing.PRICE AS PRICE
        ,pricing.TOTAL AS TOTAL
        ,pricing.TYPE1 AS TYPE1
        ,pricing.TYPE2 AS TYPE2
        ,pricing.FROMDATE AS FROMDATE
        ,pricing.TODATE AS TODATE
        ,pricing.DESCID AS DESCID
        ,pricing.P_SEQ AS P_SEQ
      FROM tmptable2 x
        ,TABLE (func_pricing2_tbl(IN_TOCODE, x.ARRKEY, 'A', startdate, x.PRICEENDDATE, currentdate, x.NRADULTS, x.CHDDOB1, x.CHDDOB2, x.CHDDOB3, x.CHDDOB4, IN_CURRENCY)) AS pricing
      )

  SELECT tooarrangement.TOCODE AS TOCODE
    ,tooarrangement.ARRKEY AS ARRKEY
    ,y.NR
    ,y.PRICE
    ,y.TOTAL
    ,y.TYPE1
    ,y.TYPE2
    ,y.FROMDATE
    ,y.TODATE
    ,y.DESCID
    ,y.P_SEQ
    ,coalesce(x.STATUS, 'XX') AS STATUS
    y.PRICETYPE
  FROM tooarrangement
  LEFT OUTER JOIN tmptable3 x ON x.ARRKEY = tooarrangement.ARRKEY
  LEFT OUTER JOIN tmptable4 y ON y.ARRKEY = tooarrangement.ARRKEY
  WHERE tooarrangement.TOCODE = IN_TOCODE
    AND tooarrangement.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), tooarrangement.DESTINATIONCODE)
    AND tooarrangement.ARRCODE = coalesce(nullif(IN_ARRCODE, ''), tooarrangement.ARRCODE)
    AND tooarrangement.ARRITEMCODE = coalesce(nullif(IN_ARRITEMCODE, ''), tooarrangement.ARRITEMCODE)
    AND tooarrangement.ARRKEY = coalesce(nullif(IN_ARRKEY, ''), tooarrangement.ARRKEY)
    AND tooarrangement.ARRLANG = IN_ARRLANG
    AND coalesce(x.STATUS, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_XX = 1
          THEN 'XX'
        ELSE '..'
        END
      )
    AND coalesce(x.STATUS, 'XX') <> (
      CASE 
        WHEN IN_IGNORE_RQ = 1
          THEN 'RQ'
        ELSE '..'
        END
      )
    AND (
      (
        IN_IGNORE_PRICE0 = 1
        AND cast(x.TOTAL AS FLOAT) > 0
        )
      OR IN_IGNORE_PRICE0 = 0
      )
  ORDER BY tooarrangement.TOCODE
    ,tooarrangement.ARRKEY
    ,(
      CASE y.TYPE1
        WHEN 'PP'
          THEN 1
        WHEN 'APP'
          THEN 2
        WHEN 'PDP'
          THEN 3
        WHEN 'APDP'
          THEN 4
        WHEN 'OT'
          THEN 5
        WHEN 'SO'
          THEN 6
        WHEN 'EB'
          THEN 7
        WHEN 'EBPCT0'
          THEN 8
        ELSE 9
        END
      ) ASC
    ,y.TYPE2 ASC
    ,y.FROMDATE ASC;
END
@

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

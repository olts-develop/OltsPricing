-- -----------------------------------------------------------------------------
-- Pricing and Availability
-- -----------------------------------------------------------------------------

DROP FUNCTION func_miscpricebydest @

-- select * from TABLE( func_miscpricebydest ('', 'AGR', cast('2015-11-12' as DATE), cast('2015-11-12' as DATE), current date, 1 ) )
CREATE FUNCTION func_miscpricebydest (
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
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,MISCKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,MISCCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  )

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  RETURN

  SELECT p_tocode
    ,toomisc.misckey
    ,func_miscpricing(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4) AS pricetotal
    ,destinationcode
    ,misccode
    ,miscitemcode
    ,func_get_allotment2(p_tocode, toomisc.misckey, 'M', p_startdate, x.ALLOTMENTENDDATE, p_currentdate )
  FROM toomisc
    , TABLE (func_miscvalid(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x
  WHERE toomisc.tocode = p_tocode
    AND toomisc.destinationcode = p_destcode
;
END
@

DROP FUNCTION func_miscpricebydest_ch @

-- select * from TABLE( func_miscpricebydest_ch ('', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
-- select * from TABLE( func_miscpricebydest_ch ('TOU', 'AGR', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_miscpricebydest_ch (
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
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,MISCKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,MISCCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  )

NOT DETERMINISTIC LANGUAGE SQL

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
    ,MISCKEY
    ,TOTAL
    ,DESTINATIONCODE
    ,MISCCODE
    ,TOURBOCODE
    ,STATUS
  FROM TABLE ( func_miscpricebydest(p_tocode, p_destcode, startdate, enddate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) )
;
END
@



DROP FUNCTION func_miscpriceav @

-- select * from TABLE( func_miscpriceav ('', cast('2015-11-12' as DATE), cast('2015-11-12' as DATE), current date, 1 ) )
CREATE FUNCTION func_miscpriceav (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_enddate DATE DEFAULT NULL
  ,p_currentdate DATE DEFAULT CURRENT DATE
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,MISCKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,MISCCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  )

NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  RETURN

  SELECT p_tocode
    ,toomisc.misckey
    ,func_miscpricing(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_currentdate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4) AS pricetotal
    ,destinationcode
    ,misccode
    ,miscitemcode
    ,func_get_allotment2(p_tocode, toomisc.misckey, 'M', p_startdate, x.ALLOTMENTENDDATE, p_currentdate )
  FROM toomisc
    , TABLE (func_miscvalid(p_tocode, toomisc.misckey, p_startdate, p_enddate, p_nradults, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x
  WHERE toomisc.tocode = p_tocode
;
END
@

DROP FUNCTION func_miscpriceav_ch @

-- select * from TABLE( func_miscpriceav_ch ('', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
-- select * from TABLE( func_miscpriceav_ch ('TSOL', '2015-11-12', '2015-11-12', '', 1 , '', '', '', '') )
CREATE FUNCTION func_miscpriceav_ch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_enddate VARCHAR(10) DEFAULT ''
  ,p_currentdate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
  )
RETURNS TABLE (
  TOCODE VARCHAR(20)
  ,MISCKEY VARCHAR(20)
  ,TOTAL DECIMAL(10, 2)
  ,DESTINATIONCODE VARCHAR(5)
  ,MISCCODE VARCHAR(30)
  ,TOURBOCODE VARCHAR(20)
  ,STATUS VARCHAR(4)
  )

NOT DETERMINISTIC LANGUAGE SQL

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
    ,MISCKEY
    ,TOTAL
    ,DESTINATIONCODE
    ,MISCCODE
    ,TOURBOCODE
    ,STATUS
  FROM TABLE ( func_miscpriceav(p_tocode, startdate, enddate, currentdate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) )
;
END
@

DROP FUNCTION func_miscpriceav2 @

-- The function func_miscpriceav2 imporves the performance of the search for misc availability and pricing dramatically.
-- It alos improves the interface that can be used to search for either a group of products, e.g. by destination,
-- or by a specific product.
--
-- Example usage:
-- select MISCKEY,TOTAL,STATUS from TABLE ( func_miscpriceav2( 'TSOL', 'BKK', '2017-05-01', '2017-05-01', 2, '', '', '', '', '', '',1, 0, 1, '','' ) );
-- This searches for all Misc products in BKK, ignoring all products with either a status XX or those without a price.
--
-- select MISCKEY,TOTAL,STATUS from TABLE ( func_miscpriceav2( '', '', '2017-04-01', '2017-04-01', 2, '', '', '', '', '', '',0, 0, 0, '','TOUWAL12828' ) );
-- This searches for a specific Misc product with the MISCKEY=TOUWAL12828. A result set is returned irrespective of the price or status.
--
-- If a search is for a specific product with a specific IN_MISCKEY, then it makes sense for the parameters
-- IN_IGNORE_XX=0
-- IN_IGNORE_RQ=0
-- IN_IGNORE_PRICE0=0
--
-- Setting these parameters only really makes sense when searching for products by destination.
--
-- Here an example of a more complex usage:
--   SELECT TOOMISC.MISCKEY AS MISCKEY
--     ,INV.TITLE AS INVTITLE
--     ,INV.DETAIL AS INVDETAIL
--     ,ITIN.TITLE AS ITINTITLE
--     ,ITIN.DETAIL AS ITINDETAIL
--     ,TOOMISC.REGION AS REGION
--     ,TOOMISC.SUBREGION AS SUBREGION
--     ,TOOMISC.COUNTRY AS COUNTRY
--     ,TOOMISC.COUNTRYISOCODE AS COUNTRYCODE
--     ,TOOMISC.DESTINATIONCODE AS DESTINATIONCODE
--     ,TOOMISC.MISCCODE AS MISCCODE
--     ,TOOMISC.MISCITEMCODE AS MISCITEMCODE
--     ,TOOMISC.MINIMUMPERSONS AS MINIMUMPERSONS
--     ,TOOMISC.MAXIMUMPERSONS AS MAXIMUMPERSONS
--     ,coalesce(x.TOTAL, 0) AS TOTAL
--     ,coalesce(x.STATUS, 'XX') AS STATUS
--   FROM TOOMISC
--   INNER JOIN TABLE (func_miscpriceav2('', 'BKK', '2017-04-01', '2017-04-01', 2, '', '', '', '', '', '', 1, 0, 1, '', '')) AS x ON x.MISCKEY = TOOMISC.MISCKEY
--   LEFT OUTER JOIN TOOMISCTEXT AS INV ON TOOMISC.MISCKEY = INV.MISCKEY
--     AND TOOMISC.TOCODE = INV.TOCODE
--     AND INV.type = 'INV'
--     AND INV.LANG = 'DE'
--   LEFT OUTER JOIN TOOMISCTEXT AS ITIN ON TOOMISC.MISCKEY = ITIN.MISCKEY
--     AND TOOMISC.TOCODE = ITIN.TOCODE
--     AND ITIN.type = 'ITIN'
--     AND ITIN.LANG = 'DE'
--   WHERE x.MISCKEY = TOOMISC.MISCKEY;
--
--
-- Here an example as used by the data center:
--
--   SELECT TOOMISC.MISCKEY            AS hotelkey
--     ,TOOMISC.MISCCODE             AS hotelcode
--     ,INV.TITLE                    AS hotelname
--     ,INV.DETAIL                   AS address1
--     ,''                           AS address2
--     ,TOOMISC.SUBREGION            AS city
--     ,TOOMISC.COUNTRY              AS country
--     ,TOOMISC.COUNTRYISOCODE       AS countrycode
--     ,TOOMISC.DESTINATIONCODE      AS code
--     ,'4.0'                        AS category
--     ,TOOMISC.MISCKEY              AS roomkey
--     ,TOOMISC.MISCCODE             AS roomcode
--     ,'EX'                         AS roomtypede
--     ,ITIN.TITLE                   AS descriptionde
--     ,TOOMISC.MISCITEMCODE         AS mealdescriptionde
--     ,TOOMISC.MISCITEMCODE         AS mealcode
--     ,TOOMISC.MAXIMUMPERSONS       AS maxadults
--     ,0                            AS extrabedchildren
--     ,TOOMISC.MINIMUMPERSONS       AS normaloccupancy
--     ,TOOMISC.MINIMUMPERSONS       AS minimaloccupancy
--     ,TOOMISC.MAXIMUMPERSONS       AS maximaloccupancy
--     ,coalesce(x.TOTAL, 0)         AS price
--     ,coalesce(x.STATUS, 'XX')     AS STATUS
--   FROM TOOMISC
--   INNER JOIN TABLE (func_miscpriceav2('TSOL', 'BKK', '2017-05-01', '2017-05-01', 2, '', '', '', '', '', '', 1, 0, 1, '', '')) AS x ON x.MISCKEY = TOOMISC.MISCKEY
--   LEFT OUTER JOIN TOOMISCTEXT AS INV ON TOOMISC.MISCKEY = INV.MISCKEY
--     AND TOOMISC.TOCODE = INV.TOCODE
--     AND INV.type = 'INV'
--     AND INV.LANG = 'DE'
--   LEFT OUTER JOIN TOOMISCTEXT AS ITIN ON TOOMISC.MISCKEY = ITIN.MISCKEY
--     AND TOOMISC.TOCODE = ITIN.TOCODE
--     AND ITIN.type = 'ITIN'
--     AND ITIN.LANG = 'DE';
--


--
CREATE FUNCTION func_miscpriceav2 (
  IN_TOCODE VARCHAR(5) DEFAULT ''
  ,IN_DESTINATIONCODE VARCHAR(5) DEFAULT ''
  ,IN_PRICEDATEFROM VARCHAR(10)
  ,IN_PRICEDATETO VARCHAR(10)
  ,IN_NRADULTS INTEGER DEFAULT 2
  ,IN_MISCCODE VARCHAR(30) DEFAULT ''
  ,IN_MISCITEMCODE VARCHAR(20) DEFAULT ''
  ,IN_CHDDOB1 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB2 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB3 VARCHAR(10) DEFAULT ''
  ,IN_CHDDOB4 VARCHAR(10) DEFAULT ''
  ,IN_IGNORE_XX INTEGER DEFAULT 0
  ,IN_IGNORE_RQ INTEGER DEFAULT 0
  ,IN_IGNORE_PRICE0 INTEGER DEFAULT 1
  ,IN_CURRENTDATE VARCHAR(10) DEFAULT ''
  ,IN_MISCKEY VARCHAR(20) DEFAULT ''
  )
RETURNS TABLE (
   TOCODE VARCHAR(5)
  ,MISCKEY VARCHAR(20)
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
  WITH tmptable1(MISCKEY, NRADULTS, CHDDOB1, CHDDOB2, CHDDOB3, CHDDOB4, PRICEENDDATE, ALLOTMENTENDDATE) AS (
      SELECT TOOMISC.MISCKEY
        ,x.NRADULTS
        ,x.CHILDBIRTHDATE1
        ,x.CHILDBIRTHDATE2
        ,x.CHILDBIRTHDATE3
        ,x.CHILDBIRTHDATE4
        ,x.PRICEENDDATE
        ,x.ALLOTMENTENDDATE
      FROM TOOMISC TOOMISC
        ,TABLE (func_miscvalid(IN_TOCODE, TOOMISC.MISCKEY, startdate, enddate, IN_NRADULTS, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)) AS x
      WHERE TOOMISC.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), TOOMISC.DESTINATIONCODE)
        AND TOOMISC.MISCCODE = coalesce(nullif(IN_MISCCODE, ''), TOOMISC.MISCCODE)
        AND TOOMISC.MISCITEMCODE = coalesce(nullif(IN_MISCITEMCODE, ''), TOOMISC.MISCITEMCODE)
        AND TOOMISC.MISCKEY = coalesce(nullif(IN_MISCKEY, ''), TOOMISC.MISCKEY)
      )
    ,tmptable2(MISCKEY, NRADULTS, CHDDOB1, CHDDOB2, CHDDOB3, CHDDOB4, PRICEENDDATE, STATUS) AS (
      SELECT x.MISCKEY
        ,x.NRADULTS
        ,x.CHDDOB1
        ,x.CHDDOB2
        ,x.CHDDOB3
        ,x.CHDDOB4
        ,x.PRICEENDDATE
        ,(
          CASE 
            WHEN (
                coalesce(TOOMISC.PASSIVE, 0) = 0
                OR (
                  TOOMISC.PASSIVE = 1
                  AND coalesce(TOOMISC.PASSIVEFROMDATE, currentdate) > currentdate
                  )
                )
              THEN func_get_allotment2(IN_TOCODE, x.MISCKEY, 'M', enddate, x.ALLOTMENTENDDATE, currentdate)
            ELSE 'XX'
            END
          )
      FROM tmptable1 x
        ,TOOMISC TOOMISC
      WHERE TOOMISC.MISCKEY = x.MISCKEY
      )
    ,tmptable3(MISCKEY, STATUS, TOTAL) AS (
      SELECT max(x.MISCKEY) AS MISCKEY
        ,max(x.STATUS) AS STATUS
        ,sum(cast(pricing.TOTAL AS FLOAT)) AS TOTAL
      FROM tmptable2 x
        ,TABLE (func_pricing2_tbl(IN_TOCODE, x.MISCKEY, 'M', startdate, x.PRICEENDDATE, currentdate, x.NRADULTS, x.CHDDOB1, x.CHDDOB2, x.CHDDOB3, x.CHDDOB4)) AS pricing
      GROUP BY x.MISCKEY
      )

  SELECT TOOMISC.TOCODE AS TOCODE
    ,TOOMISC.MISCKEY AS MISCKEY
    ,coalesce(x.TOTAL, 0) AS TOTAL
    ,coalesce(x.STATUS, 'XX') AS STATUS
  FROM TOOMISC
  LEFT OUTER JOIN tmptable3 x ON x.MISCKEY = TOOMISC.MISCKEY
  WHERE TOOMISC.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), TOOMISC.DESTINATIONCODE)
    AND TOOMISC.MISCCODE = coalesce(nullif(IN_MISCCODE, ''), TOOMISC.MISCCODE)
    AND TOOMISC.MISCITEMCODE = coalesce(nullif(IN_MISCITEMCODE, ''), TOOMISC.MISCITEMCODE)
    AND TOOMISC.MISCKEY = coalesce(nullif(IN_MISCKEY, ''), TOOMISC.MISCKEY)
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

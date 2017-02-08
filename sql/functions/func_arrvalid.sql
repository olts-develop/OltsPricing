-- -----------------------------------------------------------------------------
-- Function name: *func_arrvalid*
-- Returns a either a row with the nr adults and birth dates for the children
-- after taking into account the passed parameters and the occupancy details
-- of the specific misc, or returns an empty table.
-- -----------------------------------------------------------------------------
DROP FUNCTION func_arrvalid @

CREATE FUNCTION func_arrvalid (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_arrkey VARCHAR(20) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_enddate DATE DEFAULT NULL
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  NRADULTS INTEGER
  ,CHILDBIRTHDATE1 DATE
  ,CHILDBIRTHDATE2 DATE
  ,CHILDBIRTHDATE3 DATE
  ,CHILDBIRTHDATE4 DATE
  ,PRICEENDDATE DATE
  ,ALLOTMENTENDDATE DATE
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE childage1 DECIMAL(10, 4);
  DECLARE childage2 DECIMAL(10, 4);
  DECLARE childage3 DECIMAL(10, 4);
  DECLARE childage4 DECIMAL(10, 4);
  DECLARE totalpaxnr INTEGER;
  DECLARE enddate DATE;
  DECLARE duration INTEGER;
  DECLARE child1_hasprice INTEGER;
  DECLARE child2_hasprice INTEGER;
  DECLARE child3_hasprice INTEGER;
  DECLARE child4_hasprice INTEGER;
  DECLARE nradults INTEGER;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET childage1 = ((DAYS(p_startdate) - DAYS(p_childbirthdate1)) / 365);
  SET childage2 = ((DAYS(p_startdate) - DAYS(p_childbirthdate2)) / 365);
  SET childage3 = ((DAYS(p_startdate) - DAYS(p_childbirthdate3)) / 365);
  SET childage4 = ((DAYS(p_startdate) - DAYS(p_childbirthdate4)) / 365);
  SET totalpaxnr = p_nradults + (
      CASE 
        WHEN p_childbirthdate1 IS NOT NULL
          AND childage1 >= 2.0
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate2 IS NOT NULL
          AND childage2 >= 2.0
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate3 IS NOT NULL
          AND childage3 >= 2.0
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate4 IS NOT NULL
          AND childage4 >= 2.0
          THEN 1
        ELSE 0
        END
      );
  SET enddate = coalesce(p_enddate, p_startdate);
  SET duration = DAYS(p_enddate) - DAYS(p_startdate) + 1;
  SET child1_hasprice = (
      CASE 
        WHEN childage1 < 2
          THEN 1
        WHEN (
            SELECT count(ID)
            FROM TOOADDPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND TOOADDPERDAYPRICE.DAY = p_startdate
              AND AGEFROM <= childage1
              AND AGETO >= childage1
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOADDPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage1
              AND AGETO >= childage1
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOONETIME
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage1
              AND AGETO >= childage1
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DAY = p_startdate
              AND AGEFROM <= childage1
              AND AGETO >= childage1
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage1
              AND AGETO >= childage1
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          THEN 1
        ELSE 0
        END
      );
  SET child2_hasprice = (
      CASE 
        WHEN childage2 < 2
          THEN 1
        WHEN (
            SELECT count(ID)
            FROM TOOADDPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND TOOADDPERDAYPRICE.DAY = p_startdate
              AND AGEFROM <= childage2
              AND AGETO >= childage2
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOADDPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage2
              AND AGETO >= childage2
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOONETIME
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage2
              AND AGETO >= childage2
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DAY = p_startdate
              AND AGEFROM <= childage2
              AND AGETO >= childage2
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage2
              AND AGETO >= childage2
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          THEN 1
        ELSE 0
        END
      );
  SET child3_hasprice = (
      CASE 
        WHEN childage3 < 2
          THEN 1
        WHEN (
            SELECT count(ID)
            FROM TOOADDPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND TOOADDPERDAYPRICE.DAY = p_startdate
              AND AGEFROM <= childage3
              AND AGETO >= childage3
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOADDPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage3
              AND AGETO >= childage3
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOONETIME
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage3
              AND AGETO >= childage3
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND TOOPERDAYPRICE.DAY = p_startdate
              AND AGEFROM <= childage3
              AND AGETO >= childage3
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage3
              AND AGETO >= childage3
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          THEN 1
        ELSE 0
        END
      );
  SET child4_hasprice = (
      CASE 
        WHEN childage4 < 2
          THEN 1
        WHEN (
            SELECT count(ID)
            FROM TOOADDPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND TOOADDPERDAYPRICE.DAY = p_startdate
              AND AGEFROM <= childage4
              AND AGETO >= childage4
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOADDPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage4
              AND AGETO >= childage4
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOONETIME
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage4
              AND AGETO >= childage4
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERDAYPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND TOOPERDAYPRICE.DAY = p_startdate
              AND AGEFROM <= childage4
              AND AGETO >= childage4
              AND CHILDIDXNR > 0 FETCH first 1 row ONLY
            ) = 1
          OR (
            SELECT count(ID)
            FROM TOOPERIODPRICE
            WHERE (
                ITEMKEY
                ,ITEMTYPE
                ,TOCODE
                ,CURRENCY
                ) = (
                p_arrkey
                ,'A'
                ,p_tocode
                ,p_currency
                )
              AND DATEFROM <= p_startdate
              AND DATETO >= p_startdate
              AND AGEFROM <= childage4
              AND AGETO >= childage4
              AND CHILD = 1 FETCH first 1 row ONLY
            ) = 1
          THEN 1
        ELSE 0
        END
      );
  SET nradults = p_nradults + (
      CASE 
        WHEN p_childbirthdate1 IS NULL
          THEN 0
        WHEN child1_hasprice = 1
          THEN 0
        ELSE 1
        END
      ) + (
      CASE 
        WHEN p_childbirthdate2 IS NULL
          THEN 0
        WHEN child2_hasprice = 1
          THEN 0
        ELSE 1
        END
      ) + (
      CASE 
        WHEN p_childbirthdate3 IS NULL
          THEN 0
        WHEN child3_hasprice = 1
          THEN 0
        ELSE 1
        END
      ) + (
      CASE 
        WHEN p_childbirthdate4 IS NULL
          THEN 0
        WHEN child4_hasprice = 1
          THEN 0
        ELSE 1
        END
      );
  SET childbirthdate1 = (
      CASE 
        WHEN child1_hasprice = 1
          THEN p_childbirthdate1
        ELSE cast(NULL AS DATE)
        END
      );
  SET childbirthdate2 = (
      CASE 
        WHEN child2_hasprice = 1
          THEN p_childbirthdate2
        ELSE cast(NULL AS DATE)
        END
      );
  SET childbirthdate3 = (
      CASE 
        WHEN child3_hasprice = 1
          THEN p_childbirthdate3
        ELSE cast(NULL AS DATE)
        END
      );
  SET childbirthdate4 = (
      CASE 
        WHEN child4_hasprice = 1
          THEN p_childbirthdate4
        ELSE cast(NULL AS DATE)
        END
      );

  RETURN

  SELECT nradults
    ,func_getposdatedesc(0, 1, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4)
    ,func_getposdatedesc(0, 2, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4)
    ,func_getposdatedesc(0, 3, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4)
    ,func_getposdatedesc(0, 4, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4)
    ,enddate + 1 DAY AS PRICEENDDATE
    ,enddate + 1 DAY AS ALLOTMENTENDDATE
  FROM tooarrangement
  WHERE (
      arrkey
      ,tocode
      ) = (
      p_arrkey
      ,p_tocode
      )
    AND nradults > 0
    AND normaloccupancy + max(extrabedadults, extrabedchildren) >= nradults + (
      CASE 
        WHEN childbirthdate1 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN childbirthdate2 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN childbirthdate3 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN childbirthdate4 IS NOT NULL
          THEN 1
        ELSE 0
        END
      )
    AND normaloccupancy <= nradults + (
      CASE 
        WHEN childbirthdate1 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN childbirthdate2 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN childbirthdate3 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN childbirthdate4 IS NOT NULL
          THEN 1
        ELSE 0
        END
      );
END
@



DROP FUNCTION func_arrvalid_ch @

CREATE FUNCTION func_arrvalid_ch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_arrkey VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_enddate VARCHAR(10) DEFAULT ''
  ,p_nradults INTEGER DEFAULT 0
  ,p_childbirthdate1 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate2 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate3 VARCHAR(10) DEFAULT ''
  ,p_childbirthdate4 VARCHAR(10) DEFAULT ''
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
  )
RETURNS TABLE (
  NRADULTS INTEGER
  ,CHILDBIRTHDATE1 DATE
  ,CHILDBIRTHDATE2 DATE
  ,CHILDBIRTHDATE3 DATE
  ,CHILDBIRTHDATE4 DATE
  -- The misc might be start date relevant only, which affects
  -- the pricing and/or allotment SQL function parameters.
  ,PRICEENDDATE DATE
  ,ALLOTMENTENDDATE DATE
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE startdate DATE;
  DECLARE enddate DATE;
  DECLARE childbirthdate1 DATE;
  DECLARE childbirthdate2 DATE;
  DECLARE childbirthdate3 DATE;
  DECLARE childbirthdate4 DATE;

  SET startdate = cast(nullif(p_startdate, '') AS DATE);
  SET enddate = cast(nullif(p_enddate, '') AS DATE);
  SET childbirthdate1 = cast(nullif(p_childbirthdate1, '') AS DATE);
  SET childbirthdate2 = cast(nullif(p_childbirthdate2, '') AS DATE);
  SET childbirthdate3 = cast(nullif(p_childbirthdate3, '') AS DATE);
  SET childbirthdate4 = cast(nullif(p_childbirthdate4, '') AS DATE);

  RETURN

  SELECT x.NRADULTS
    ,x.CHILDBIRTHDATE1
    ,x.CHILDBIRTHDATE2
    ,x.CHILDBIRTHDATE3
    ,x.CHILDBIRTHDATE4
    ,x.PRICEENDDATE
    ,x.ALLOTMENTENDDATE
  FROM TABLE (func_arrvalid(p_tocode, p_arrkey, startdate, enddate, p_nradults, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4, p_currency)) AS x;
END
@
  -- -----------------------------------------------------------------------------
  -- EOF
  -- -----------------------------------------------------------------------------

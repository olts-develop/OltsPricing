DROP FUNCTION func_flightvalid @

CREATE FUNCTION func_flightvalid (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_flightkey VARCHAR(20) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
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
  ) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  DECLARE childage1 DECIMAL(10, 4);
  DECLARE childage2 DECIMAL(10, 4);
  DECLARE childage3 DECIMAL(10, 4);
  DECLARE childage4 DECIMAL(10, 4);
  DECLARE totalpaxnr INTEGER;
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
  SET child1_hasprice = (
      CASE 
        WHEN childage1 < 2
          THEN 1
        WHEN (
            SELECT count(ID)
            FROM TOOPERDAYFLIGHTPRICE
            WHERE (
                ITEMKEY
                ,TOOPERDAYFLIGHTPRICE.TOCODE
                ,CURRENCY
                ) = (
                p_flightkey
                ,p_tocode
                ,p_currency
                )
              AND DAY = p_startdate
              AND AGEFROM <= childage1
              AND AGETO >= childage1
              AND CHILDIDXNR = 1 FETCH first 1 row ONLY
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
            FROM TOOPERDAYFLIGHTPRICE
            WHERE (
                ITEMKEY
                ,TOOPERDAYFLIGHTPRICE.TOCODE
                ,CURRENCY
                ) = (
                p_flightkey
                ,p_tocode
                ,p_currency
                )
              AND DAY = p_startdate
              AND AGEFROM <= childage2
              AND AGETO >= childage2
              AND CHILDIDXNR = 2 FETCH first 1 row ONLY
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
            FROM TOOPERDAYFLIGHTPRICE
            WHERE (
                ITEMKEY
                ,TOOPERDAYFLIGHTPRICE.TOCODE
                ,CURRENCY
                ) = (
                p_flightkey
                ,p_tocode
                ,p_currency
                )
              AND DAY = p_startdate
              AND AGEFROM <= childage3
              AND AGETO >= childage3
              AND CHILDIDXNR = 3 FETCH first 1 row ONLY
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
            FROM TOOPERDAYFLIGHTPRICE
            WHERE (
                ITEMKEY
                ,TOOPERDAYFLIGHTPRICE.TOCODE
                ,CURRENCY
                ) = (
                p_flightkey
                ,p_tocode
                ,p_currency
                )
              AND DAY = p_startdate
              AND AGEFROM <= childage4
              AND AGETO >= childage4
              AND CHILDIDXNR = 4 FETCH first 1 row ONLY
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
  FROM
    tooflightleg
  WHERE
    tooflightleg.legkey = p_flightkey
    AND tooflightleg.tocode = p_tocode
    AND nradults > 0
    ;
END

@
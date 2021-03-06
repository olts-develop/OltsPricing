-- -----------------------------------------------------------------------------
-- Function name: *func_roomvalid*

-- Returns a either a row with the nr adults and birth dates for the children
-- after taking into account the passed parameters and the occupancy details
-- of the specific room, or returns an empty table.

-- If i am trying to book a double room, but have only one adult and one child,
-- the child could be interpreted as an adult and this occupany permutation
-- could still be placed in this room. This function would change the 
-- nr persons from 1 to 2, and remove the birthdate of the child.
-- -----------------------------------------------------------------------------

drop function func_roomvalid @

CREATE FUNCTION func_roomvalid (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_roomkey VARCHAR(20) DEFAULT ''
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

  RETURN

  SELECT (
      CASE 
        WHEN normaloccupancy > p_nradults
          THEN normaloccupancy
        ELSE p_nradults
        END
      )
    ,func_getposdatedesc((
        CASE 
          WHEN normaloccupancy > p_nradults
            THEN normaloccupancy - p_nradults
          ELSE 0
          END
        ), 1, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
    ,func_getposdatedesc((
        CASE 
          WHEN normaloccupancy > p_nradults
            THEN normaloccupancy - p_nradults
          ELSE 0
          END
        ), 2, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
    ,func_getposdatedesc((
        CASE 
          WHEN normaloccupancy > p_nradults
            THEN normaloccupancy - p_nradults
          ELSE 0
          END
        ), 3, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
    ,func_getposdatedesc((
        CASE 
          WHEN normaloccupancy > p_nradults
            THEN normaloccupancy - p_nradults
          ELSE 0
          END
        ), 4, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4)
  FROM toorooms
  WHERE (
      roomkey
      ,tocode
      ) = (
      p_roomkey
      ,p_tocode
      )
    AND p_nradults <= normaloccupancy + extrabedadults
    AND p_nradults > 0
    AND normaloccupancy + extrabedadults + extrabedchildren >= p_nradults + (
      CASE 
        WHEN p_childbirthdate1 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate2 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate3 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate4 IS NOT NULL
          THEN 1
        ELSE 0
        END
      )
    AND normaloccupancy <= p_nradults + (
      CASE 
        WHEN p_childbirthdate1 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate2 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate3 IS NOT NULL
          THEN 1
        ELSE 0
        END
      ) + (
      CASE 
        WHEN p_childbirthdate4 IS NOT NULL
          THEN 1
        ELSE 0
        END
      );
END
@

--
-- This is a room with normaloccupancy = 2.
-- With two adults, both fill the normaloccupancy.
-- SELECT
--   *
-- FROM
--   TABLE( func_roomvalid( 'IMHO', 'TUIXYA192344', 2, date('2016-10-03'), cast(NULL as DATE) ) )
--
--  TOCODE  ROOMKEY       NRADULTS  CHILDBIRTHDATE1  CHILDBIRTHDATE2  CHILDBIRTHDATE3  CHILDBIRTHDATE4
--  ------  ------------  --------  ---------------  ---------------  ---------------  ---------------
--           TUIXYA192344        2 2016-10-03        NULL              NULL              NULL
--
-- However with only one adult a child can take the place of an adult, paying the adult price.
-- Note the function will return NRADULTS = 2, even though 1 was passed as a parameter.
-- SELECT
--   *
-- FROM
--   TABLE( func_roomvalid( 'IMHO', 'TUIXYA192344', 1, date('2016-10-03'), cast(NULL as DATE) ) )
--
--  TOCODE  ROOMKEY       NRADULTS  CHILDBIRTHDATE1  CHILDBIRTHDATE2  CHILDBIRTHDATE3  CHILDBIRTHDATE4
--  ------  ------------  --------  ---------------  ---------------  ---------------  ---------------
--           TUIXYA192344        2 NULL              NULL              NULL              NULL
--
-- Only one adult may not book the double room. The function will return an empty result set:
-- SELECT
--   *
-- FROM
--   TABLE( func_roomvalid( 'IMHO', 'TUIXYA192344', 1, cast(NULL as DATE), cast(NULL as DATE) ) )
--
--  TOCODE  ROOMKEY       NRADULTS  CHILDBIRTHDATE1  CHILDBIRTHDATE2  CHILDBIRTHDATE3  CHILDBIRTHDATE4
--  ------  ------------  --------  ---------------  ---------------  ---------------  ---------------
-- Fetched 0 records
--

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

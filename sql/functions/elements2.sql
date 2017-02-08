-- -----------------------------------------------------------------------------
-- Function name: *elemIdx2*, *elements2*

-- elements2: Takes a sting and a delimiter, then parses the string using the
-- delimiter, returning a table which lists each delimited part in the string
-- with the corresponding index number in the list.

-- elemIdx2: Helper function for *elements2*
-- -----------------------------------------------------------------------------

drop function elemIdx2 @

CREATE FUNCTION elemIdx2 (
  string VARCHAR(2000)
  ,delimiter VARCHAR(20)
  )
RETURNS TABLE (
  ORDINAL INTEGER
  ,INDEX INTEGER
  ) LANGUAGE SQL DETERMINISTIC NO EXTERNAL ACTION CONTAINS SQL

RETURN
WITH t(ordinal, INDEX) AS (
    VALUES (
      0
      ,0
      )
    
    UNION ALL
    
    SELECT ordinal + 1
      ,COALESCE(NULLIF(LOCATE(coalesce(nullif(delimiter, ''), ','), string, INDEX + LENGTH(coalesce(nullif(delimiter, ''), ','))), 0), LENGTH(string) + LENGTH(coalesce(nullif(delimiter, ''), ',')))
    FROM t
    WHERE ordinal < 10000
      AND LOCATE(coalesce(nullif(delimiter, ''), ','), string, INDEX + LENGTH(coalesce(nullif(delimiter, ''), ','))) <> 0
    )

SELECT ordinal
  ,INDEX
FROM t

UNION ALL

SELECT MAX(ordinal) + 1
  ,LENGTH(string) + 1
FROM t
@


drop function elements2 @

CREATE FUNCTION elements2 (
  string VARCHAR(2000)
  ,delimiter VARCHAR(20)
  )
RETURNS TABLE (
  ELEMENT VARCHAR(2000)
  ,INDEX INTEGER
  ) LANGUAGE SQL DETERMINISTIC NO EXTERNAL ACTION CONTAINS SQL

RETURN
WITH t(ordinal, INDEX) AS (
    SELECT ordinal
      ,INDEX
    FROM TABLE (elemIdx2(string, coalesce(NULLIF(delimiter, ''), ','))) AS x
    )

SELECT SUBSTR(string, t1.INDEX + (
      CASE 
        WHEN t1.ordinal = 0
          THEN 1
        ELSE LENGTH(coalesce(NULLIF(delimiter, ''), ','))
        END
      ), t2.INDEX - t1.INDEX - 1) AS ELEMENT
  ,t1.ordinal AS INDEX
FROM t AS t1
JOIN t AS t2 ON (t2.ordinal = t1.ordinal + 1)

@

--
-- select t.elem,t.index from TABLE( elements2( '4,5,66,777',',' ) ) as t( elem, index )
--
--  ELEM   INDEX
--  ----   -----
--  4         0
--  5         1
--  66        2
--  777       3
--

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

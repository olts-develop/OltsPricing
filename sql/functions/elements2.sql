-- -----------------------------------------------------------------------------
-- Function name: *elemIdx2*, *elements2*

-- elements2: Takes a sting and a delimiter, then parses the string using the
-- delimiter, returning a table which lists each delimited part in the string
-- with the corresponding index number in the list.

-- elemIdx2: Helper function for *elements2*
-- -----------------------------------------------------------------------------

drop function elemIdx2 @

create function elemIdx2
(
  string VARCHAR(2000)
  ,delimiter VARCHAR(20)
)
RETURNS
  TABLE
  (
    ORDINAL INTEGER
    ,INDEX INTEGER
  )
LANGUAGE SQL
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
RETURN
WITH t(ordinal, index) AS
(
  VALUES ( 0, 0 )
  UNION ALL
  SELECT
    ordinal + 1
    ,COALESCE(
      NULLIF( LOCATE( coalesce(nullif(delimiter,''), ','), string, index + LENGTH(coalesce(nullif(delimiter,''), ',')) ), 0 )
      ,LENGTH(string) + LENGTH(coalesce(nullif(delimiter,''),','))
    )
  FROM
    t
  WHERE
    ordinal < 10000
    AND LOCATE( coalesce(nullif(delimiter,''), ',') , string, index + LENGTH(coalesce(nullif(delimiter,''), ',')) ) <> 0
)
SELECT
  ordinal
  , index
FROM
  t
UNION ALL
SELECT
  MAX(ordinal) + 1
  ,LENGTH(string) + 1
FROM
  t
@


drop function elements2 @

create function elements2
(
  string VARCHAR(2000)
  ,delimiter VARCHAR(20)
)
RETURNS
  TABLE
  (
    ELEMENT VARCHAR(2000)
    ,INDEX INTEGER
  )
LANGUAGE SQL
DETERMINISTIC
NO EXTERNAL ACTION
CONTAINS SQL
RETURN
WITH t(ordinal, index) AS
(
  SELECT
    ordinal
    ,index
  FROM
    TABLE( elemIdx2( string, coalesce(NULLIF (delimiter,''), ',') ) ) AS x
)
SELECT
  SUBSTR(string, t1.index + (case when t1.ordinal=0 then 1 else LENGTH(coalesce(NULLIF (delimiter,''),',')) end), t2.index - t1.index - 1) as ELEMENT
  ,t1.ordinal as INDEX
FROM
  t AS t1
  JOIN t AS t2 ON ( t2.ordinal = t1.ordinal + 1 )
@

--
-- select t.elem,t.index from TABLE( elements2( '4,5,66,777',',' ) ) as t( elem, index )
--
--  ELEM 	INDEX
--  ---- 	-----
--  4   	    0
--  5   	    1
--  66  	    2
--  777 	    3
--

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

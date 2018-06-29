-- -----------------------------------------------------------------------------
-- Function name: *func_get_allotment2*, *func_get_allotment2ch*

-- Return values: XX, RQ, FS, '1', '2', '3', '4', ...

-- Function returns 'XX' if not allotment or request, 'RQ' if only request,
-- or a number as a string indicating the available allotment for
-- the requested parameters, e.g. "2" if there are two rooms available.
-- If this item is for free sell, i.e. can always be booked, "FS" is returned.
-- -----------------------------------------------------------------------------

drop function func_get_allotment2 @

create function func_get_allotment2
(
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_returndate DATE DEFAULT NULL
  ,p_currentdate DATE DEFAULT CURRENT DATE
)
RETURNS
  VARCHAR(4)
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

DECLARE av INTEGER ;
DECLARE rq INTEGER ;
DECLARE fs INTEGER ;
DECLARE max_min_stay_num INTEGER ;
DECLARE counter INTEGER ;
DECLARE daysbetweenstartend INTEGER ;

IF ( p_startdate IS NULL or p_returndate IS NULL ) THEN
  RETURN 'XX';
END IF;

SET daysbetweenstartend = ( DAYS(p_returndate) - DAYS(p_startdate) );

IF ( p_currentdate < CURRENT DATE ) THEN
  RETURN 'XX';
END IF;

SET (counter, av, rq, fs, max_min_stay_num) =
(
SELECT
  COUNT(id), MIN(av), MIN(rq), MIN(fs), MAX(days(minstay)-days(allotdate)+1)
FROM
  tooallotments
WHERE
  (itemkey, tocode, itemtype) = (p_itemkey, p_tocode, p_itemtype)
  AND allotdate >= p_startdate
  AND allotdate < p_returndate
  AND rel > p_currentdate
)
;

IF ( counter < daysbetweenstartend ) THEN
  RETURN 'XX';
ELSEIF ( av > 0 AND max_min_stay_num > daysbetweenstartend AND rq > 0) THEN
  RETURN 'RQ'; -- Request
ELSEIF ( av > 0 AND max_min_stay_num > daysbetweenstartend AND rq = 0) THEN
  RETURN 'XX';
ELSEIF ( av > 0 AND av <= 9999 ) THEN
  RETURN RTRIM(cast(AV as VARCHAR(4))); -- 1, 2, 3, etc. if allotment
ELSEIF ( av > 9999 ) THEN  
  RETURN '9999';
ELSEIF ( fs > 0 ) THEN
  RETURN 'FS';  -- Free sell
ELSEIF ( rq > 0 ) THEN
  RETURN 'RQ'; -- Request
ELSE
  RETURN 'XX'; -- Unavailable
END IF;

END
@


drop function func_get_allotment2ch @

CREATE FUNCTION func_get_allotment2ch (
  p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(20) DEFAULT ''
  ,p_startdate VARCHAR(10) DEFAULT ''
  ,p_returndate VARCHAR(10) DEFAULT ''
  ,p_currentdate VARCHAR(10) DEFAULT ''
  )
RETURNS VARCHAR(4) NOT DETERMINISTIC LANGUAGE SQL

BEGIN
  ATOMIC

  RETURN

  SELECT func_get_allotment2(p_tocode, p_itemkey, p_itemtype, cast(NULLIF(p_startdate, '') AS DATE), cast(NULLIF(p_returndate, '') AS DATE), coalesce(cast(NULLIF(p_currentdate, '') AS DATE), CURRENT DATE))
  FROM sysibm.sysdummy1;
END
@

-- select func_get_allotment2 ('', 'STOGVA60414', 'H', DATE('2015-07-30'), DATE('2015-09-23'), CURRENT DATE ) from sysibm.sysdummy1

-- select func_get_allotment2ch ('', 'STOGVA60414', 'H', '2015-07-30', '2015-09-23', '' ) from sysibm.sysdummy1

-- select
-- x.*
-- ,func_get_allotment2 (x.TOCODE, x.ROOMKEY, 'H', DATE('2015-09-10'), DATE('2015-09-23'), current date )
-- from
-- TABLE( func_roompricebydest ('', 'MRU', DATE('2015-09-10'), DATE('2015-09-25'),current date, 2 ) ) as x
-- where
-- TOTAL > 0
-- and func_get_allotment2 (x.TOCODE, x.ROOMKEY, 'H', DATE('2015-09-10'), DATE('2015-09-23'), current date ) <> 'XX'

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

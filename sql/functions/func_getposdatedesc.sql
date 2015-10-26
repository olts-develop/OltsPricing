-- -----------------------------------------------------------------------------
-- Function name: *func_getposdatedesc*

-- Return values: The specific date out of the ordered four params for the
-- specified poistion

-- From a list of date parameters, ignore the first x and fetch a specific
-- date from the list. The date positions are ordered des
-- -----------------------------------------------------------------------------

drop function func_getposdatedesc @

create function func_getposdatedesc
(
  p_ignorenr INTEGER DEFAULT 0
  ,p_getposition INTEGER DEFAULT 1
  ,p_bd1 VARCHAR(10) DEFAULT '' -- first date
  ,p_bd2 VARCHAR(10) DEFAULT '' -- second date
  ,p_bd3 VARCHAR(10) DEFAULT '' -- third date
  ,p_bd4 VARCHAR(10) DEFAULT '' -- fourth date
)
RETURNS
  DATE
DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

DECLARE offset INTEGER;
SET offset = p_ignorenr + p_getposition;

IF ( p_bd1 = '' and p_bd2 = '' and p_bd3 = '' and p_bd4 = '' ) THEN
  RETURN cast(NULL as DATE);
ELSE
  RETURN
    SELECT
      bd
    FROM
    (
      SELECT
        bd
        ,ROW_NUMBER() OVER(ORDER BY bd DESC NULLS LAST) AS rownum
      FROM
        ( values cast(p_bd1 as DATE) , cast(p_bd2 as DATE), cast(p_bd3 as DATE), cast(p_bd4 as DATE) ) as x (bd)
    ) AS y (bd,rownum)
    WHERE
      rownum = offset
  ;
  END IF;
END
@

--
-- Get the second largest date of a list of four unordered dates ignoring the first 1 dates:
-- select
--    func_getposdatedesc( 1,2, date('2014-05-01'), cast(NULL as DATE), date('2012-05-01'), date('2013-05-01') ) as DATEVAL
-- from
--    sysibm.sysdummy1
--
-- DATEVAL
-- ----------
-- 2012-05-01
--
-- Get the third largest date of a list of four unordered dates ignoring the first 1 dates:
-- select
--    func_getposdatedesc( 1,3, date('2014-05-01'), cast(NULL as DATE), date('2012-05-01'), date('2013-05-01') ) as DATEVAL
--  from
--     sysibm.sysdummy1
--
-- DATEVAL
-- ------
-- NULL
--
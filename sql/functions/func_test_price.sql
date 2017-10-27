-- -----------------------------------------------------------------------------
-- Function name: *func_test_price*

-- Return values: OK, XX

-- Function returns 'OK' if there is a PDP, PP or APP for all days in the
-- booking period. If on any day in the booking period a price is missing,
-- the function will return 'XX'.
-- -----------------------------------------------------------------------------

drop function func_test_price @

create function func_test_price
(
   p_tocode VARCHAR(5) DEFAULT ''
  ,p_itemkey VARCHAR(20) DEFAULT ''
  ,p_itemtype VARCHAR(1) DEFAULT ''
  ,p_startdate DATE DEFAULT NULL
  ,p_returndate DATE DEFAULT NULL
  ,p_adultnr INTEGER DEFAULT 0
  ,p_childbirthdate1 DATE DEFAULT NULL
  ,p_childbirthdate2 DATE DEFAULT NULL
  ,p_childbirthdate3 DATE DEFAULT NULL
  ,p_childbirthdate4 DATE DEFAULT NULL
  ,p_currency VARCHAR(3) DEFAULT 'CHF'
)
RETURNS
  VARCHAR(2)
NOT DETERMINISTIC
LANGUAGE SQL
BEGIN ATOMIC

  DECLARE daysbetweenstartend INTEGER;  
  DECLARE counter INTEGER;

  SET daysbetweenstartend = ( DAYS(p_returndate) - DAYS(p_startdate) );

SET counter = 
  (
    SELECT
      COUNT(DISTINCT TMPDAY)
    FROM
      TOOTMPDAY
      ,TABLE (FUNC_ALL_PDP_PP_APP_TBL(p_tocode, p_itemkey, p_itemtype , p_startdate, p_returndate, p_adultnr, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
    WHERE
      X.TYPE1 in ('PDP','PP','APP')
      AND p_itemtype='H'
      AND TMPDAY BETWEEN x.fromdate AND x.todate
  ) + (
    SELECT
      COUNT(DISTINCT TMPDAY)
    FROM
      TOOTMPDAY
      ,TABLE (func_all_ot_tbl(p_tocode, p_itemkey, p_itemtype , p_startdate, p_returndate, p_adultnr, p_childbirthdate1, p_childbirthdate2, p_childbirthdate3, p_childbirthdate4, p_currency)) AS x
    WHERE
      X.TYPE1 in ('OT')
      AND p_itemtype='M'
      AND TMPDAY BETWEEN x.fromdate AND x.todate
  )
  ;
         
IF ( counter = daysbetweenstartend AND counter > 0 ) THEN
  -- RETURN RTRIM(cast(counter as VARCHAR(10)));
  RETURN 'OK';
ELSE
  RETURN 'XX';
END IF;

END
@

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

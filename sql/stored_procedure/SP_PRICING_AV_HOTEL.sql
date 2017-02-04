--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
CREATE
	OR REPLACE PROCEDURE SP_PRICING_AV_HOTEL (
	IN IN_TOCODE VARCHAR(5)
	,IN IN_LANGCODE VARCHAR(2) DEFAULT 'DE'
	,IN IN_DESTINATIONCODE VARCHAR(5)
	,IN IN_PRICEDATEFROM VARCHAR(10)
	,IN IN_PRICEDATETO VARCHAR(10)
	,IN IN_NORMALOCCUPANCY INTEGER DEFAULT 2
	,IN IN_HOTELCODE VARCHAR(30) DEFAULT ''
	,IN IN_ROOMCODE VARCHAR(20) DEFAULT ''
	,IN IN_TOURBOMEALCODE VARCHAR(5) DEFAULT ''
	,IN IN_CHDDOB1 VARCHAR(10) DEFAULT ''
	,IN IN_CHDDOB2 VARCHAR(10) DEFAULT ''
	,IN IN_CHDDOB3 VARCHAR(10) DEFAULT ''
	,IN IN_CHDDOB4 VARCHAR(10) DEFAULT ''
	,IN IN_IGNORE_XX INTEGER DEFAULT 0
	,IN IN_IGNORE_RQ INTEGER DEFAULT 0
	,IN IN_IGNORE_PRICE0 INTEGER DEFAULT 1
	,IN IN_CURRENTDATE VARCHAR(10) DEFAULT ''
	,IN IN_ROOMKEY VARCHAR(20) DEFAULT ''
	,IN IN_HOTELKEY VARCHAR(20) DEFAULT ''
	) DYNAMIC RESULT SETS 1

P1:

BEGIN
	DECLARE pricedatefrom DATE;
	DECLARE pricedateto DATE;
	DECLARE childbirthdate1 DATE;
	DECLARE childbirthdate2 DATE;
	DECLARE childbirthdate3 DATE;
	DECLARE childbirthdate4 DATE;
	DECLARE currentdate DATE;

	SET pricedatefrom = cast(nullif(IN_PRICEDATEFROM, '') as date);
	SET pricedateto = cast(nullif(IN_PRICEDATETO, '') as date);
	SET childbirthdate1 = cast(nullif(IN_CHDDOB1, '') as date);
	SET childbirthdate2 = cast(nullif(IN_CHDDOB2, '') as date);
	SET childbirthdate3 = cast(nullif(IN_CHDDOB3, '') as date);
	SET childbirthdate4 = cast(nullif(IN_CHDDOB4, '') as date);
	SET currentdate = coalesce(cast(nullif(IN_CURRENTDATE, '') as date), CURRENT DATE);

	P2:

	BEGIN
		-- Declare cursor
		DECLARE cursor1 CURSOR WITH RETURN
		for
		-- #######################################################################
		-- # Returns sum of price for specific hotel item
		--
		--   Parameters for "func_pricing":
		--    p_tocode VARCHAR(5) DEFAULT ''
		--   ,p_itemkey VARCHAR(20) DEFAULT ''
		--   ,p_startdate DATE DEFAULT NULL -- start of booking period
		--   ,p_returndate DATE DEFAULT NULL -- end of booking period (this is the departure date of the room, not the last date relevant for pricing)
		--   ,p_currentdate DATE DEFAULT CURRENT DATE
		--   ,p_nradults INTEGER DEFAULT 0
		--   ,p_childbirthdate1 DATE DEFAULT NULL
		--   ,p_childbirthdate2 DATE DEFAULT NULL
		--   ,p_childbirthdate3 DATE DEFAULT NULL
		--   ,p_childbirthdate4 DATE DEFAULT NULL
		--     
		--   Parameters for func_get_allotment2:
		--    p_tocode VARCHAR(5) DEFAULT ''
		--   ,p_itemkey VARCHAR(20) DEFAULT ''
		--   ,p_itemtype VARCHAR(1) DEFAULT ''
		--   ,p_startdate DATE DEFAULT NULL
		--   ,p_returndate DATE DEFAULT NULL
		--   ,p_currentdate DATE DEFAULT CURRENT DATE
		-- #######################################################################
		with tmptble (
			XHOTELKEY
			,XROOMKEY
			,XPRICE
			,XALLTOMENTCODE
			)
		as (
			(
				select h.HOTELKEY
					,r.ROOMKEY
					,cast(func_pricing(IN_TOCODE, r.ROOMKEY, pricedatefrom, pricedateto, currentdate, IN_NORMALOCCUPANCY, childbirthdate1, childbirthdate2, childbirthdate3, childbirthdate4) as FLOAT) as price
					,func_get_allotment2(IN_TOCODE, r.ROOMKEY, 'H', pricedatefrom, pricedateto, currentdate) as status
				from TOOHOTEL h
				INNER JOIN TOOROOMS r on h.HOTELKEY = r.HOTELKEY
				where h.DESTINATIONCODE = coalesce(nullif(IN_DESTINATIONCODE, ''), h.DESTINATIONCODE)
					and h.HOTELCODE = coalesce(nullif(IN_HOTELCODE, ''), h.HOTELCODE)
					and r.TOURBOCODE = coalesce(nullif(IN_ROOMCODE, ''), r.TOURBOCODE)
					and r.TOURBOMEALCODE = coalesce(nullif(IN_TOURBOMEALCODE, ''), r.TOURBOMEALCODE)
					and r.ROOMKEY = coalesce(nullif(IN_ROOMKEY, ''), r.ROOMKEY)
					and h.HOTELKEY = coalesce(nullif(IN_HOTELKEY, ''), h.HOTELKEY)
					and r.NORMALOCCUPANCY = IN_NORMALOCCUPANCY
					and (
						coalesce(r.PASSIVE, 0) = 0
						or (
							r.PASSIVE = 1
							and coalesce(r.FROMDATE, current date) > current date
							)
						)
				)
			) select h.HOTELKEY as HOTELKEY
			,h.HOTELCODE as HOTELCODE
			,(
			case upper(IN_LANGCODE)
				when 'EN'
					then h.HOTELNAMEEN
				when 'FR'
					then h.HOTELNAMEFR
				when 'IT'
					then h.HOTELNAMEIT
				else h.HOTELNAMEDE
				end
			) as HOTELNAME
			,h.ADDRESS1 as ADDRESS1
			,h.ADDRESS2 as ADDRESS2
			,h.CITY asCITY
			,h.COUNTRY as COUNTRY
			,h.COUNTRYISOCODE as COUNTRYCODE
			,h.DESTINATIONCODE as DESTINATIONCODE
			,h.CATEGORY as CATEGORY
			,r.ROOMKEY as ROOMKEY
			,(
			case upper(IN_LANGCODE)
				when 'EN'
					then r.ROOMTYPEEN
				when 'FR'
					then r.ROOMTYPEFR
				when 'IT'
					then r.ROOMTYPEIT
				else r.ROOMTYPEDE
				end
			) as ROOMTYPE
			,(
			case upper(IN_LANGCODE)
				when 'EN'
					then r.DESCRIPTIONEN
				when 'FR'
					then r.DESCRIPTIONFR
				when 'IT'
					then r.DESCRIPTIONIT
				else r.DESCRIPTIONDE
				end
			) as DESCRIPTION
			,(
			case upper(IN_LANGCODE)
				when 'EN'
					then r.MEALDESCRIPTIONEN
				when 'FR'
					then r.MEALDESCRIPTIONFR
				when 'IT'
					then r.MEALDESCRIPTIONIT
				else r.MEALDESCRIPTIONDE
				end
			) as MEALDESCRIPTION
			,r.TOURBOMEALCODE as MEALCODE
			,r.MAXADULTS as MAXADULTS
			,r.EXTRABEDCHILDREN as EXTRABEDCHILDREN
			,r.NORMALOCCUPANCY as NORMALOCCUPANCY
			,r.MINIMALOCCUPANCY as MINIMALOCCUPANCY
			,r.MAXIMALOCCUPANCY as MAXIMALOCCUPANCY
			,coalesce (
			XPRICE
			,0
			) as PRICE
			,coalesce (
			XALLTOMENTCODE
			,'XX'
			) as STATUS
			,h.GIATAID as GIATAID from TOOHOTEL h INNER JOIN TOOROOMS r on h.HOTELKEY = r.HOTELKEY LEFT OUTER JOIN tmptble on h.HOTELKEY = XHOTELKEY
			and r.ROOMKEY = XROOMKEY where h.DESTINATIONCODE = coalesce (
			nullif(IN_DESTINATIONCODE, '')
			,h.DESTINATIONCODE
			)
			and h.HOTELCODE = coalesce (
			nullif(IN_HOTELCODE, '')
			,h.HOTELCODE
			)
			and r.TOURBOCODE = coalesce (
			nullif(IN_ROOMCODE, '')
			,r.TOURBOCODE
			)
			and r.TOURBOMEALCODE = coalesce (
			nullif(IN_TOURBOMEALCODE, '')
			,r.TOURBOMEALCODE
			)
			and r.ROOMKEY = coalesce (
			nullif(IN_ROOMKEY, '')
			,r.ROOMKEY
			)
			and h.HOTELKEY = coalesce (
			nullif(IN_HOTELKEY, '')
			,h.HOTELKEY
			)
			and r.NORMALOCCUPANCY = IN_NORMALOCCUPANCY
			and (
			(
				IN_IGNORE_PRICE0 = 1
				and XPRICE > 0
				)
			or IN_IGNORE_PRICE0 = 0
			)
			and coalesce (
			XALLTOMENTCODE
			,'XX'
			) <> (
			case 
				when IN_IGNORE_XX = 1
					then 'XX'
				else '..'
				end
			)
			and coalesce (
			XALLTOMENTCODE
			,'XX'
			) <> (
			case 
				when IN_IGNORE_RQ = 1
					then 'RQ'
				else '..'
				end
			) order by (
			case IN_LANGCODE
				when 'EN'
					then h.HOTELNAMEEN
				when 'FR'
					then h.HOTELNAMEFR
				when 'IT'
					then h.HOTELNAMEIT
				else h.HOTELNAMEDE
				end
			)
			,h.HOTELKEY
			,coalesce (
			XPRICE
			,0
			);
		-- Cursor left open for client application
		OPEN cursor1;
	END P2;
END P1

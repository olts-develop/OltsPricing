CREATE
	OR REPLACE PROCEDURE SP_SALESFORCE_CUSTOMER (IN FILTER_MODDATETIME VARCHAR(26) DEFAULT '') DYNAMIC RESULT SETS 1

P1:

BEGIN
	DECLARE cursor1 CURSOR WITH RETURN
	FOR
	SELECT SALESFORCECUSTOMER.PRIMARYKEY
		,SALESFORCECUSTOMER.SALUTATION
		,SALESFORCECUSTOMER.TITLE
		,SALESFORCECUSTOMER.FIRSTNAME
		,SALESFORCECUSTOMER.LASTNAME
		,SALESFORCECUSTOMER.STREET1
		,SALESFORCECUSTOMER.STREET2
		,SALESFORCECUSTOMER.COUNTRYCODE
		,SALESFORCECUSTOMER.POSTALCODE
		,SALESFORCECUSTOMER.CITY
		,SALESFORCECUSTOMER.PHONE
		,SALESFORCECUSTOMER.PHONEBUSINESS
		,SALESFORCECUSTOMER.MOBILE
		,SALESFORCECUSTOMER.CUSTOMERNR
		,SALESFORCECUSTOMER.BIRTHDATE
		,SALESFORCECUSTOMER.MAIL1
		,SALESFORCECUSTOMER.MAIL2
		,SALESFORCECUSTOMER.LOCKED
		,SALESFORCECUSTOMER.LANGUAGE
		,SALESFORCECUSTOMER.MAILING
		,SALESFORCECUSTOMER.TYPE
		,SALESFORCECUSTOMER.NROFFILES
		,SALESFORCECUSTOMER.NROFPRINTEDFILES
		,SALESFORCECUSTOMER.NONSMOKER
		,SALESFORCECUSTOMER.SMOKER
		,SALESFORCECUSTOMER.AISLE
		,SALESFORCECUSTOMER.WINDOW
		,SALESFORCECUSTOMER.SPECIALMEALCODE
		,SALESFORCECUSTOMER.SPECIALSEATCODE
		,SALESFORCECUSTOMER.TRAINHALBTAX
		,SALESFORCECUSTOMER.TRAINHALBTAXEXPIRY
		,SALESFORCECUSTOMER.TRAINGA
		,SALESFORCECUSTOMER.TRAINGAEXPIRY
		,SALESFORCECUSTOMER.TRAINNRYEARS
		,SALESFORCECUSTOMER.TRAINCLASS
		,SALESFORCECUSTOMER.PASSPORTNATIONALITY
		,SALESFORCECUSTOMER.PASSPORTBIRTHTOWN
		,SALESFORCECUSTOMER.PASSPORTNUMBER
		,SALESFORCECUSTOMER.PASSPORTVALIDUNTIL
		,SALESFORCECUSTOMER.PASSPORTPLACEOFISSUE
		,SALESFORCECUSTOMER.PASSPORTISSUEDATE
		,SALESFORCECUSTOMER.JOB
		,SALESFORCECUSTOMER.LAST10DESTINATIONS
		,SALESFORCECUSTOMER.MODDATETIME
		,SALESFORCECUSTOMER.MD5
		,SALESFORCECUSTOMER.ACTION
		,SALESFORCECUSTOMER.LOCKEDREASON
	FROM SALESFORCECUSTOMER SALESFORCECUSTOMER
	WHERE SALESFORCECUSTOMER.MODDATETIME > cast(coalesce(NULLIF(FILTER_MODDATETIME, ''), current timestamp - 50 years) as TIMESTAMP)
	ORDER BY SALESFORCECUSTOMER.MODDATETIME ASC;

	-- Cursor left open for client application
	OPEN cursor1;
END

P1
@

CREATE
	OR REPLACE PROCEDURE SP_SALESFORCE_DOSSIER (IN FILTER_MODDATETIME VARCHAR(26) DEFAULT '') DYNAMIC RESULT SETS 1

P1:

BEGIN
	DECLARE cursor1 CURSOR WITH RETURN
	FOR
	SELECT SALESFORCEDOSSIER.PRIMARYKEY
		,SALESFORCEDOSSIER.CUSTOMERFK
		,SALESFORCEDOSSIER.CUSTOMERNR
		,SALESFORCEDOSSIER.DOSSIERNR
		,SALESFORCEDOSSIER.REVISIONNR
		,SALESFORCEDOSSIER.DESTINATIONCODE
		,SALESFORCEDOSSIER.TURNOVERNETTO
		,SALESFORCEDOSSIER.DEPDATE
		,SALESFORCEDOSSIER.CREATEDATE
		,SALESFORCEDOSSIER.DOSSIERSTATE
		,SALESFORCEDOSSIER.NRPAX
		,SALESFORCEDOSSIER.RETURNDATE
		,SALESFORCEDOSSIER.NROFFERSPRINTED
		,SALESFORCEDOSSIER.NRINVOICESPRINTED
		,SALESFORCEDOSSIER.NRCREDITNOTESPRINTED
		,SALESFORCEDOSSIER.FIRSTOFFERPRINTDATE
		,SALESFORCEDOSSIER.LASTOFFERPRINTDATE
		,SALESFORCEDOSSIER.FIRSTINVOICEPRINTDATE
		,SALESFORCEDOSSIER.LASTINVOICEPRINTDATE
		,SALESFORCEDOSSIER.FIRSTCREDITNOTEPRINTDATE
		,SALESFORCEDOSSIER.LASTCREDITNOTEPRINTDATE
		,SALESFORCEDOSSIER.MODDATETIME
		,SALESFORCEDOSSIER.MD5
		,SALESFORCEDOSSIER.ACTION
		,SALESFORCEDOSSIER.TURNOVERBRUTTO
		,SALESFORCEDOSSIER.CODE1
		,SALESFORCEDOSSIER.CODE2
		,SALESFORCEDOSSIER.CODE3
		,SALESFORCEDOSSIER.CODE4
		,SALESFORCEDOSSIER.SCORE
		,SALESFORCEDOSSIER.TITLE
		,SALESFORCEDOSSIER.TITLECODE
		,SALESFORCEDOSSIER.OWNERCODE
		,SALESFORCEDOSSIER.OWNERNAME
	FROM SALESFORCEDOSSIER SALESFORCEDOSSIER
	WHERE SALESFORCEDOSSIER.MODDATETIME > cast(coalesce(NULLIF(FILTER_MODDATETIME, ''), current timestamp - 50 years) as TIMESTAMP)
	ORDER BY SALESFORCEDOSSIER.MODDATETIME ASC;

	-- Cursor left open for client application
	OPEN cursor1;
END

P1
@

CREATE
	OR REPLACE PROCEDURE SP_SALESFORCE_MEMBERSHIP (IN FILTER_MODDATETIME VARCHAR(26) DEFAULT '') DYNAMIC RESULT SETS 1

P1:

BEGIN
	DECLARE cursor1 CURSOR WITH RETURN
	FOR
	SELECT SALESFORCEMEMBERSHIP.PRIMARYKEY
		,SALESFORCEMEMBERSHIP.NUMBER
		,SALESFORCEMEMBERSHIP.EXPIRY
		,SALESFORCEMEMBERSHIP.NUMBER2
		,SALESFORCEMEMBERSHIP.TYPE
		,SALESFORCEMEMBERSHIP.CODE
		,SALESFORCEMEMBERSHIP.CODEDESC
		,SALESFORCEMEMBERSHIP.CUSTOMERFK
		,SALESFORCEMEMBERSHIP.CUSTOMERNR
		,SALESFORCEMEMBERSHIP.MODDATETIME
		,SALESFORCEMEMBERSHIP.MD5
		,SALESFORCEMEMBERSHIP.ACTION
	FROM SALESFORCEMEMBERSHIP SALESFORCEMEMBERSHIP
	WHERE SALESFORCEMEMBERSHIP.MODDATETIME > cast(coalesce(NULLIF(FILTER_MODDATETIME, ''), current timestamp - 50 years) as TIMESTAMP)
	ORDER BY SALESFORCEMEMBERSHIP.MODDATETIME ASC;

	-- Cursor left open for client application
	OPEN cursor1;
END

P1
@
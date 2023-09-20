CREATE OR REPLACE PROCEDURE SP_SALESFORCE_CUSTOMER
    (
    IN FILTER_MODDATETIME VARCHAR(26) DEFAULT ''
    ) DYNAMIC
    RESULT SETS 1 P1:
        BEGIN
            DECLARE cursor1 CURSOR WITH
            RETURN FOR
            SELECT
                SALESFORCECUSTOMER.PRIMARYKEY           ,
                SALESFORCECUSTOMER.SALUTATION           ,
                SALESFORCECUSTOMER.TITLE                ,
                SALESFORCECUSTOMER.FIRSTNAME            ,
                SALESFORCECUSTOMER.LASTNAME             ,
                SALESFORCECUSTOMER.STREET1              ,
                SALESFORCECUSTOMER.STREET2              ,
                SALESFORCECUSTOMER.COUNTRYCODE          ,
                SALESFORCECUSTOMER.POSTALCODE           ,
                SALESFORCECUSTOMER.CITY                 ,
                SALESFORCECUSTOMER.PHONE                ,
                SALESFORCECUSTOMER.PHONEBUSINESS        ,
                SALESFORCECUSTOMER.MOBILE               ,
                SALESFORCECUSTOMER.CUSTOMERNR           ,
                SALESFORCECUSTOMER.BIRTHDATE            ,
                SALESFORCECUSTOMER.MAIL1                ,
                SALESFORCECUSTOMER.MAIL2                ,
                SALESFORCECUSTOMER.LOCKED               ,
                SALESFORCECUSTOMER.LANGUAGE             ,
                SALESFORCECUSTOMER.MAILING              ,
                SALESFORCECUSTOMER.TYPE                 ,
                SALESFORCECUSTOMER.NROFFILES            ,
                SALESFORCECUSTOMER.NROFPRINTEDFILES     ,
                SALESFORCECUSTOMER.NONSMOKER            ,
                SALESFORCECUSTOMER.SMOKER               ,
                SALESFORCECUSTOMER.AISLE                ,
                SALESFORCECUSTOMER.WINDOW               ,
                SALESFORCECUSTOMER.SPECIALMEALCODE      ,
                SALESFORCECUSTOMER.SPECIALSEATCODE      ,
                SALESFORCECUSTOMER.TRAINHALBTAX         ,
                SALESFORCECUSTOMER.TRAINHALBTAXEXPIRY   ,
                SALESFORCECUSTOMER.TRAINGA              ,
                SALESFORCECUSTOMER.TRAINGAEXPIRY        ,
                SALESFORCECUSTOMER.TRAINNRYEARS         ,
                SALESFORCECUSTOMER.TRAINCLASS           ,
                SALESFORCECUSTOMER.PASSPORTNATIONALITY  ,
                SALESFORCECUSTOMER.PASSPORTBIRTHTOWN    ,
                SALESFORCECUSTOMER.PASSPORTNUMBER       ,
                SALESFORCECUSTOMER.PASSPORTVALIDUNTIL   ,
                SALESFORCECUSTOMER.PASSPORTPLACEOFISSUE ,
                SALESFORCECUSTOMER.PASSPORTISSUEDATE    ,
                SALESFORCECUSTOMER.JOB                  ,
                SALESFORCECUSTOMER.LAST10DESTINATIONS   ,
                SALESFORCECUSTOMER.MODDATETIME          ,
                SALESFORCECUSTOMER.MD5                  ,
                SALESFORCECUSTOMER.ACTION               ,
                SALESFORCECUSTOMER.LOCKEDREASON         ,
                SALESFORCECUSTOMER.SOURCE
            FROM
                SALESFORCECUSTOMER SALESFORCECUSTOMER
            WHERE
                SALESFORCECUSTOMER.MODDATETIME > cast(coalesce(NULLIF(FILTER_MODDATETIME, ''), current timestamp - 50 years) as TIMESTAMP)
            ORDER BY
                SALESFORCECUSTOMER.MODDATETIME ASC;
            -- Cursor left open for client application
            OPEN cursor1;
        END
    P1 @

CREATE OR REPLACE PROCEDURE SP_SALESFORCE_DOSSIER
    (
    IN FILTER_MODDATETIME VARCHAR(26) DEFAULT ''
    ) DYNAMIC
    RESULT SETS 1 P1:
        BEGIN
            DECLARE cursor1 CURSOR WITH
            RETURN FOR
            SELECT
                SALESFORCEDOSSIER.PRIMARYKEY               ,
                SALESFORCEDOSSIER.CUSTOMERFK               ,
                SALESFORCEDOSSIER.CUSTOMERNR               ,
                SALESFORCEDOSSIER.DOSSIERNR                ,
                SALESFORCEDOSSIER.REVISIONNR               ,
                SALESFORCEDOSSIER.DESTINATIONCODE          ,
                SALESFORCEDOSSIER.TURNOVERNETTO            ,
                SALESFORCEDOSSIER.DEPDATE                  ,
                SALESFORCEDOSSIER.CREATEDATE               ,
                SALESFORCEDOSSIER.DOSSIERSTATE             ,
                SALESFORCEDOSSIER.NRPAX                    ,
                SALESFORCEDOSSIER.RETURNDATE               ,
                SALESFORCEDOSSIER.NROFFERSPRINTED          ,
                SALESFORCEDOSSIER.NRINVOICESPRINTED        ,
                SALESFORCEDOSSIER.NRCREDITNOTESPRINTED     ,
                SALESFORCEDOSSIER.FIRSTOFFERPRINTDATE      ,
                SALESFORCEDOSSIER.LASTOFFERPRINTDATE       ,
                SALESFORCEDOSSIER.FIRSTINVOICEPRINTDATE    ,
                SALESFORCEDOSSIER.LASTINVOICEPRINTDATE     ,
                SALESFORCEDOSSIER.FIRSTCREDITNOTEPRINTDATE ,
                SALESFORCEDOSSIER.LASTCREDITNOTEPRINTDATE  ,
                SALESFORCEDOSSIER.MODDATETIME              ,
                SALESFORCEDOSSIER.MD5                      ,
                SALESFORCEDOSSIER.ACTION                   ,
                SALESFORCEDOSSIER.TURNOVERBRUTTO           ,
                SALESFORCEDOSSIER.CODE1                    ,
                SALESFORCEDOSSIER.CODE2                    ,
                SALESFORCEDOSSIER.CODE3                    ,
                SALESFORCEDOSSIER.CODE4                    ,
                SALESFORCEDOSSIER.SCORE                    ,
                SALESFORCEDOSSIER.TITLE                    ,
                SALESFORCEDOSSIER.TITLECODE                ,
                SALESFORCEDOSSIER.OWNERCODE                ,
                SALESFORCEDOSSIER.OWNERNAME
            FROM
                SALESFORCEDOSSIER SALESFORCEDOSSIER
            WHERE
                SALESFORCEDOSSIER.MODDATETIME > cast(coalesce(NULLIF(FILTER_MODDATETIME, ''), current timestamp - 50 years) as TIMESTAMP)
            ORDER BY
                SALESFORCEDOSSIER.MODDATETIME ASC;
            -- Cursor left open for client application
            OPEN cursor1;
        END
    P1 @

CREATE OR REPLACE PROCEDURE SP_SALESFORCE_MEMBERSHIP
    (
    IN FILTER_MODDATETIME VARCHAR(26) DEFAULT ''
    ) DYNAMIC
    RESULT SETS 1 P1:
        BEGIN
            DECLARE cursor1 CURSOR WITH
            RETURN FOR
            SELECT
                SALESFORCEMEMBERSHIP.PRIMARYKEY  ,
                SALESFORCEMEMBERSHIP.NUMBER      ,
                SALESFORCEMEMBERSHIP.EXPIRY      ,
                SALESFORCEMEMBERSHIP.NUMBER2     ,
                SALESFORCEMEMBERSHIP.TYPE        ,
                SALESFORCEMEMBERSHIP.CODE        ,
                SALESFORCEMEMBERSHIP.CODEDESC    ,
                SALESFORCEMEMBERSHIP.CUSTOMERFK  ,
                SALESFORCEMEMBERSHIP.CUSTOMERNR  ,
                SALESFORCEMEMBERSHIP.MODDATETIME ,
                SALESFORCEMEMBERSHIP.MD5         ,
                SALESFORCEMEMBERSHIP.ACTION
            FROM
                SALESFORCEMEMBERSHIP SALESFORCEMEMBERSHIP
            WHERE
                SALESFORCEMEMBERSHIP.MODDATETIME > cast(coalesce(NULLIF(FILTER_MODDATETIME, ''), current timestamp - 50 years) as TIMESTAMP)
            ORDER BY
                SALESFORCEMEMBERSHIP.MODDATETIME ASC;
            -- Cursor left open for client application
            OPEN cursor1;
        END
    P1 @
    --WARNING! ERRORS ENCOUNTERED DURING SQL PARSING! (FEEDBACK TO https://github.com/TaoK/PoorMansTSqlFormatter/commits)

CREATE OR REPLACE PROCEDURE SP_SALESFORCE_CUSTOMER_ACTION
    (
    IN IN_ACTION        VARCHAR(26) DEFAULT 'GET' ,
    IN IN_CUSTOMER_NR   INTEGER DEFAULT 0         ,
    IN IN_SALUTATION    VARCHAR(25) DEFAULT ''    ,
    IN IN_TITLE         VARCHAR(50) DEFAULT ''    ,
    IN IN_FIRSTNAME     VARCHAR(30) DEFAULT ''    ,
    IN IN_LASTNAME      VARCHAR(60) DEFAULT ''    ,
    IN IN_STREET1       VARCHAR(50) DEFAULT ''    ,
    IN IN_STREET2       VARCHAR(100) DEFAULT ''   ,
    IN IN_COUNTRYCODE   VARCHAR(3) DEFAULT ''     ,
    IN IN_POSTALCODE    VARCHAR(20) DEFAULT ''    ,
    IN IN_CITY          VARCHAR(50) DEFAULT ''    ,
    IN IN_PHONE         VARCHAR(60) DEFAULT ''    ,
    IN IN_PHONEBUSINESS VARCHAR(60) DEFAULT ''    ,
    IN IN_MOBILE        VARCHAR(60) DEFAULT ''    ,
    IN IN_BIRTHDATE     VARCHAR(10) DEFAULT ''    ,
    IN IN_MAIL1         VARCHAR(80) DEFAULT ''    ,
    IN IN_MAIL2         VARCHAR(80) DEFAULT ''    ,
    IN IN_LANGUAGE      VARCHAR(3) DEFAULT ''     ,
    IN IN_MAILING       VARCHAR(3) DEFAULT 'YES'  ,
    IN IN_TYPE          VARCHAR(20) DEFAULT 'PRIVATE'
    ) DYNAMIC
    RESULT SETS 1 MODIFIES SQL DATA P1:
        BEGIN
            ATOMIC DECLARE NextCustomerNr INTEGER DEFAULT 0;
            DECLARE Customer_Type_Seq     VARCHAR(20) DEFAULT '';
            DECLARE Payment_Condition_Seq VARCHAR(20) DEFAULT '';
            DECLARE Rechempf_Seq          VARCHAR(20) DEFAULT '';
            /* CENTRAL will fetch and increment the GLOBAL table, which BRANCH will fetch and UPDATE the REPGLOBAL for the branch */
            DECLARE BIRTHDATE_AS_DATE DATE;
            DECLARE Customer_Nr_Type  VARCHAR(20) DEFAULT 'CENTRAL';
            DECLARE ErrorCode         VARCHAR(254) DEFAULT '';
            DECLARE ErrorDesc         VARCHAR(254) DEFAULT '';
            DECLARE Orig_In_Action    VARCHAR(254) DEFAULT '';
            /* The cursor "cursor1" will be the result returned by the SQL in the case of success, and
        is
            identical to the result of a call to SP_SALESFORCE_CUSTOMER */
            DECLARE cursor1 CURSOR WITH
            RETURN FOR
            SELECT
                Orig_In_Action   AS IN_ACTION           ,
                IN_ACTION        AS IN_EFF_ACTION       ,
                "IN_CUSTOMER_NR" AS IN_CUSTOMERNR       ,
                'ok'             as "OUT_STATUS"        ,
                ''               AS "OUT_ERROR"         ,
                ''               AS "OUT_ERRORDESC"     ,
                Rechempf_Seq     AS Rechempf_Seq        ,
                SALESFORCECUSTOMER.PRIMARYKEY           ,
                SALESFORCECUSTOMER.SALUTATION           ,
                SALESFORCECUSTOMER.TITLE                ,
                SALESFORCECUSTOMER.FIRSTNAME            ,
                SALESFORCECUSTOMER.LASTNAME             ,
                SALESFORCECUSTOMER.STREET1              ,
                SALESFORCECUSTOMER.STREET2              ,
                SALESFORCECUSTOMER.COUNTRYCODE          ,
                SALESFORCECUSTOMER.POSTALCODE           ,
                SALESFORCECUSTOMER.CITY                 ,
                SALESFORCECUSTOMER.PHONE                ,
                SALESFORCECUSTOMER.PHONEBUSINESS        ,
                SALESFORCECUSTOMER.MOBILE               ,
                SALESFORCECUSTOMER.CUSTOMERNR           ,
                SALESFORCECUSTOMER.BIRTHDATE            ,
                SALESFORCECUSTOMER.MAIL1                ,
                SALESFORCECUSTOMER.MAIL2                ,
                SALESFORCECUSTOMER.LOCKED               ,
                SALESFORCECUSTOMER.LANGUAGE             ,
                SALESFORCECUSTOMER.MAILING              ,
                SALESFORCECUSTOMER.TYPE                 ,
                SALESFORCECUSTOMER.NROFFILES            ,
                SALESFORCECUSTOMER.NROFPRINTEDFILES     ,
                SALESFORCECUSTOMER.NONSMOKER            ,
                SALESFORCECUSTOMER.SMOKER               ,
                SALESFORCECUSTOMER.AISLE                ,
                SALESFORCECUSTOMER.WINDOW               ,
                SALESFORCECUSTOMER.SPECIALMEALCODE      ,
                SALESFORCECUSTOMER.SPECIALSEATCODE      ,
                SALESFORCECUSTOMER.TRAINHALBTAX         ,
                SALESFORCECUSTOMER.TRAINHALBTAXEXPIRY   ,
                SALESFORCECUSTOMER.TRAINGA              ,
                SALESFORCECUSTOMER.TRAINGAEXPIRY        ,
                SALESFORCECUSTOMER.TRAINNRYEARS         ,
                SALESFORCECUSTOMER.TRAINCLASS           ,
                SALESFORCECUSTOMER.PASSPORTNATIONALITY  ,
                SALESFORCECUSTOMER.PASSPORTBIRTHTOWN    ,
                SALESFORCECUSTOMER.PASSPORTNUMBER       ,
                SALESFORCECUSTOMER.PASSPORTVALIDUNTIL   ,
                SALESFORCECUSTOMER.PASSPORTPLACEOFISSUE ,
                SALESFORCECUSTOMER.PASSPORTISSUEDATE    ,
                SALESFORCECUSTOMER.JOB                  ,
                SALESFORCECUSTOMER.LAST10DESTINATIONS   ,
                SALESFORCECUSTOMER.MODDATETIME          ,
                SALESFORCECUSTOMER.MD5                  ,
                SALESFORCECUSTOMER.ACTION               ,
                SALESFORCECUSTOMER.LOCKEDREASON         ,
                SALESFORCECUSTOMER.SOURCE
            FROM
                SALESFORCECUSTOMER SALESFORCECUSTOMER
            WHERE
                SALESFORCECUSTOMER.CUSTOMERNR = IN_CUSTOMER_NR
            ORDER BY
                SALESFORCECUSTOMER.MODDATETIME ASC;
            
            DECLARE errorcursor1 CURSOR WITH
            RETURN FOR
            SELECT
                Orig_In_Action   AS IN_ACTION     ,
                IN_ACTION        AS IN_EFF_ACTION ,
                "IN_CUSTOMER_NR" AS IN_CUSTOMERNR ,
                'error'          as "OUT_STATUS"  ,
                ErrorCode        AS "OUT_ERROR"   ,
                ErrorDesc        AS "OUT_ERRORDESC"
            FROM
                SYSIBM.SYSDUMMY1;
            /* Clean up parameters that have possibly been sent in lowercase or capitalized */
            SET Orig_In_Action   = COALESCE(IN_ACTION,'');
            SET IN_ACTION        = UPPER(COALESCE("IN_ACTION", 'GET'));
            SET IN_CUSTOMER_NR   = COALESCE(IN_CUSTOMER_NR, 0);
            SET IN_SALUTATION    = COALESCE(IN_SALUTATION, '');
            SET IN_TITLE         = COALESCE(IN_TITLE, '');
            SET IN_FIRSTNAME     = COALESCE(IN_FIRSTNAME, '');
            SET IN_LASTNAME      = COALESCE(IN_LASTNAME, '');
            SET IN_STREET1       = COALESCE(IN_STREET1, '');
            SET IN_STREET2       = COALESCE(IN_STREET2, '');
            SET IN_COUNTRYCODE   = COALESCE(IN_COUNTRYCODE, '');
            SET IN_POSTALCODE    = COALESCE(IN_POSTALCODE, '');
            SET IN_CITY          = COALESCE(IN_CITY, '');
            SET IN_PHONE         = COALESCE(IN_PHONE, '');
            SET IN_PHONEBUSINESS = COALESCE(IN_PHONEBUSINESS, '');
            SET IN_MOBILE        = COALESCE(IN_MOBILE, '');
            SET IN_BIRTHDATE     = COALESCE(IN_BIRTHDATE, '');
            SET IN_MAIL1         = COALESCE(IN_MAIL1, '');
            SET IN_MAIL2         = COALESCE(IN_MAIL2, '');
            SET IN_LANGUAGE      = UPPER(COALESCE(IN_LANGUAGE, ''));
            SET IN_MAILING       = UPPER(COALESCE(IN_MAILING, 'YES'));
            SET IN_TYPE          = UPPER(COALESCE(IN_TYPE, 'PRIVATE'));
            /* IN_ACTION */
            SET IN_ACTION =
            CASE
                IN_ACTION
            WHEN
                ''
            THEN
                'GET'
            ELSE
                IN_ACTION
            END;
            /* TYPE */
            SET IN_TYPE =
            CASE
                IN_TYPE
            WHEN
                'AGENT'
            THEN
                'AGENT'
            WHEN
                'B2BCOMPANY'
            THEN
                'B2BCOMPANY'
            ELSE
                'PRIVATE'
            END;
            /* LANGUAGE */
            SET IN_LANGUAGE =
            CASE
                IN_LANGUAGE
            WHEN
                ''
            THEN
                'DE'
            ELSE
                IN_LANGUAGE
            END;
            /* MAILING */
            SET IN_MAILING =
            CASE
                IN_MAILING
            WHEN
                '1'
            THEN
                'YES'
            WHEN
                '0'
            THEN
                'NO'
            WHEN
                'TRUE'
            THEN
                'YES'
            WHEN
                'FALSE'
            THEN
                'NO'
            WHEN
                ''
            THEN
                'YES'
            ELSE
                IN_MAILING
            END;
            /* IF IN_ACTION = 'INSERT' AND LASTNAME <> '' */
            IF
                IN_ACTION       = 'INSERT'
                AND IN_LASTNAME <> ''
            THEN
                /*
                INSERT   INSERT   INSERT   INSERT
                In the case of an INSERT, I need to fetch the payment condition seq, and the customer type seq.
                Then I need to insert the new RECHEMPF, and then a new SALESFORCE_CUSTOMER record.
                This will allow me to return a valid SP_SALESFORCE_CUSTOMER response.
                */
                /* Customer_Nr_Type */
                SELECT
                    UPPER(GV_TEXTVAL)
                INTO
                    Customer_Nr_Type
                FROM
                    DB2ADMIN.GENERALVALUES
                WHERE
                    GV_KEY1 = 'SALESFORCE'
                AND GV_KEY2 = 'CREATE_CUSTOMER'
                AND GV_KEY3 = 'CUSTOMER_NR_SOURCE'
                FETCH FIRST 1 ROW ONLY;
                
                SET Customer_Nr_Type = COALESCE(Customer_Nr_Type, 'CENTRAL');
                /* CENTRAL will fetch and increment the GLOBAL table, which BRANCH will fetch and UPDATE the REPGLOBAL for the branch */
                IF
                    /* CENTRAL will fetch and increment the GLOBAL table */
                    Customer_Nr_Type = 'CENTRAL'
                THEN
                    SELECT
                        GL_KUNDENNBR
                    INTO
                        NextCustomerNr
                    FROM
                        "GLOBAL"
                    WHERE
                        GL_UNIQUEID = 1
                    FETCH FIRST 1 ROW ONLY;
                    
                    SET IN_CUSTOMER_NR = NextCustomerNr;
                    UPDATE
                        "GLOBAL"
                    SET
                        "GL_KUNDENNBR" = GL_KUNDENNBR + 1
                    WHERE
                        GL_UNIQUEID = 1;
                
                ELSE
                    /* BRANCH will fetch and UPDATE the REPGLOBAL for the branch */
                    SELECT
                        REPGL_LONGINT
                    INTO
                        NextCustomerNr
                    FROM
                        REPGLOBAL
                    WHERE
                        REPGL_NAME    = 'GL_KUNDENNBR'
                    AND REPGL_COMPANY = 'TOU'
                    AND REPGL_OFFICE  = 'WAL'
                    FETCH FIRST 1 ROW ONLY;
                    
                    SET IN_CUSTOMER_NR = NextCustomerNr;
                    UPDATE
                        REPGLOBAL
                    SET
                        REPGL_LONGINT = REPGL_LONGINT + 1
                    WHERE
                        REPGL_NAME    = 'GL_KUNDENNBR'
                    AND REPGL_COMPANY = 'TOU'
                    AND REPGL_OFFICE  = 'WAL';
                
                END IF;
                /* Payment_Condition_Seq */
                SELECT
                    ZA_SEQ
                INTO
                    Payment_Condition_Seq
                FROM
                    DB2ADMIN.ZAHLUNGSKOND
                WHERE
                    UPPER(ZA_SHORTDEUTSSCH) =
                    (
                        SELECT
                            UPPER(GV_TEXTVAL)
                        FROM
                            DB2ADMIN.GENERALVALUES
                        WHERE
                            GV_KEY1 = 'SALESFORCE'
                        AND GV_KEY2 = 'CREATE_CUSTOMER'
                        AND GV_KEY3 = 'DEFAULT_PAYMENT_CONDITION'
                        FETCH FIRST 1 ROW ONLY );
                
                SET Payment_Condition_Seq = COALESCE(Payment_Condition_Seq, '');
                /* Customer_Type_Seq */
                SELECT
                    KUT_SEQ
                INTO
                    Customer_Type_Seq
                FROM
                    DB2ADMIN.KUNDENTYP
                WHERE
                    UPPER(KUT_KURZ) =
                    CASE
                        IN_LANGUAGE
                    WHEN
                        'EN'
                    THEN
                        (
                            SELECT
                                UPPER(GV_TEXTVAL)
                            FROM
                                DB2ADMIN.GENERALVALUES
                            WHERE
                                GV_KEY1 = 'SALESFORCE'
                            AND GV_KEY2 = 'CREATE_CUSTOMER'
                            AND GV_KEY3 = 'DEFAULT_CUSTOMER_TYPE_E'
                            FETCH FIRST 1 ROW ONLY )
                    WHEN
                        'FR'
                    THEN
                        (
                            SELECT
                                UPPER(GV_TEXTVAL)
                            FROM
                                DB2ADMIN.GENERALVALUES
                            WHERE
                                GV_KEY1 = 'SALESFORCE'
                            AND GV_KEY2 = 'CREATE_CUSTOMER'
                            AND GV_KEY3 = 'DEFAULT_CUSTOMER_TYPE_F'
                            FETCH FIRST 1 ROW ONLY )
                    WHEN
                        'IT'
                    THEN
                        (
                            SELECT
                                UPPER(GV_TEXTVAL)
                            FROM
                                DB2ADMIN.GENERALVALUES
                            WHERE
                                GV_KEY1 = 'SALESFORCE'
                            AND GV_KEY2 = 'CREATE_CUSTOMER'
                            AND GV_KEY3 = 'DEFAULT_CUSTOMER_TYPE_I'
                            FETCH FIRST 1 ROW ONLY )
                    ELSE
                        (
                            SELECT
                                UPPER(GV_TEXTVAL)
                            FROM
                                DB2ADMIN.GENERALVALUES
                            WHERE
                                GV_KEY1 = 'SALESFORCE'
                            AND GV_KEY2 = 'CREATE_CUSTOMER'
                            AND GV_KEY3 = 'DEFAULT_CUSTOMER_TYPE_D'
                            FETCH FIRST 1 ROW ONLY )
                    END;
                
                SET Customer_Type_Seq = COALESCE(Customer_Type_Seq, '');
                /* INSERT RECHEMPF */
                INSERT INTO "DB2ADMIN"."RECHEMPF"
                    (
                        "R_SEQ"                ,
                        "R_ZASEQ"              ,
                        "R_SUREGSEQ"           ,
                        "R_TYP"                ,
                        "R_ANREDE1"            ,
                        "R_VORNAME1"           ,
                        "R_NAME1"              ,
                        "R_ANREDE2"            ,
                        "R_VORNAME2"           ,
                        "R_NAME2"              ,
                        "R_STRASSE"            ,
                        "R_STRASSEZUSATZ"      ,
                        "R_PLZ"                ,
                        "R_ORT"                ,
                        "R_KANTON"             ,
                        "R_LAND"               ,
                        "R_OPALNR"             ,
                        "R_TEL"                ,
                        "R_FAX"                ,
                        "R_INTERNET"           ,
                        "R_TELVOR"             ,
                        "R_FAXVOR"             ,
                        "R_KUNDENNBR"          ,
                        "R_GEBURTSTAG"         ,
                        "R_JAHRGANG"           ,
                        "R_SEL01"              ,
                        "R_SEL02"              ,
                        "R_SEL03"              ,
                        "R_SALUTATION"         ,
                        "R_LANG"               ,
                        "R_COMTYP"             ,
                        "R_COMTYPTEXT"         ,
                        "R_MAILING"            ,
                        "R_NEW"                ,
                        "R_TELGESCHAEFT"       ,
                        "R_PASSNUMMER"         ,
                        "R_AUSSTELLUNGSDATUM"  ,
                        "R_AUSSTELLUNGSORT"    ,
                        "R_TELGESCHAEFTVOR"    ,
                        "R_NATELVOR"           ,
                        "R_NATEL"              ,
                        "R_BUCHUNGSBERECHTIGT" ,
                        "R_ROBINSON"           ,
                        "R_TELNICHT"           ,
                        "R_FAXVORG"            ,
                        "R_FAXG"               ,
                        "R_TEXT"               ,
                        "R_SUCOANREDE"         ,
                        "R_SUCONAME"           ,
                        "R_SUCOVORNAME"        ,
                        "R_SUEKPROZ"           ,
                        "R_SUZENTRALE"         ,
                        "R_SUDEBI"             ,
                        "R_SUCREDI"            ,
                        "R_SUCODE"             ,
                        "R_SUINFO"             ,
                        "R_SUPPLIER"           ,
                        "R_MA"                 ,
                        "R_MAPASSWORD"         ,
                        "R_MAUSERLEVEL"        ,
                        "R_MAKUERZEL"          ,
                        "R_TRANSPTYP"          ,
                        "R_WAEHRUNG"           ,
                        "R_MODUSER"            ,
                        "R_MODDATE"            ,
                        "R_CREATEUSER"         ,
                        "R_CREATEDATE"         ,
                        "R_MAPROFITCENTER"     ,
                        "R_ANREDECODE"         ,
                        "R_STANDARDSUPPLIER"   ,
                        "R_SUBKNTTYPE"         ,
                        "R_NOMAILING"          ,
                        "R_INTERNLSV"          ,
                        "R_VERSANDNUMMER"      ,
                        "R_AILINENUMMER"       ,
                        "R_EKKREDI"            ,
                        "R_COPS"               ,
                        "R_ABTEILUNG"          ,
                        "R_MACOMPANY"          ,
                        "R_MASTR1"             ,
                        "R_MASTR2"             ,
                        "R_MALAND"             ,
                        "R_MAPLZ"              ,
                        "R_MAORT"              ,
                        "R_MATELVOR"           ,
                        "R_MATEL"              ,
                        "R_MAFAXVOR"           ,
                        "R_MAFAX"              ,
                        "R_MAMAIL"             ,
                        "R_GUIDEDAIRLINE"      ,
                        "R_CRSPRIV"            ,
                        "R_CRSCOMP"            ,
                        "R_KEINEZSCHEIN"       ,
                        "R_MAID"               ,
                        "R_TOUR_USERID"        ,
                        "R_TOUR_PASSWD"        ,
                        "R_TOUR_SYSTEM"        ,
                        "R_TOUR_AGENCY"        ,
                        "R_TRAVID"             ,
                        "R_SERVICECODE"        ,
                        "R_AMEX"               ,
                        "R_DINERS"             ,
                        "R_DISPLAYFILTER"      ,
                        "R_COPSBETRAG"         ,
                        "R_AIRPLUS"            ,
                        "R_COPSBETRAGEUR"      ,
                        "R_COPSBETRAGFW1"      ,
                        "R_COPSBETRAGFW2"      ,
                        "R_CREDITLIMIT"        ,
                        "R_TTSEXPORTTYPE"      ,
                        "R_CLOSESTAIRPORT1"    ,
                        "R_CLOSESTAIRPORT2"    ,
                        "R_TO_CRS"             ,
                        "R_CC_DETAILLIST"      ,
                        "R_MAINAKTIV"          ,
                        "R_MARABATT"           ,
                        "R_GEBSEQ"             ,
                        "R_AGENT"              ,
                        "R_ADD_EMAIL"          ,
                        "R_MAKUERZELSTAMM"     ,
                        "R_SEX_NAME"           ,
                        "R_SEX_VORNAME"        ,
                        "R_SEX_NAME_VORNAME"   ,
                        "R_SEX_VORNAME_NAME"   ,
                        "R_ANSEQ"              ,
                        "R_AN_ANREDE"          ,
                        "R_AN_TITEL"           ,
                        "R_PAYNET_ID"          ,
                        "R_MA_GUI_LANG"        ,
                        "R_EXTERNEBOOKINGCODE" ,
                        "R_GROUPCODE"          ,
                        "R_TRAVID2"            ,
                        "R_DOCEMAILPREFERRED"  ,
                        "R_BSSEQ"              ,
                        "R_GEBSEQ2"            ,
                        "R_ORGCODE"            ,
                        "R_GEBURTSTAG2"        ,
                        "R_DIREKTINKASSO"      ,
                        "R_KUNDEKEINEMWST"     ,
                        "R_MERLINNR"           ,
                        "R_JACKPLUSNR"         ,
                        "R_VOUCHERMAIL"        ,
                        "R_MWSTERST"           ,
                        "R_ORGANISATION"
                    )
                VALUES
                    (
                        CAST(NEXTVAL FOR SEQ_RECHEMPF AS VARCHAR(20)) ,
                        Payment_Condition_Seq                         ,
                        ''                                            ,
                        Customer_Type_Seq                             ,
                        IN_SALUTATION                                 ,
                        IN_FIRSTNAME                                  ,
                        IN_LASTNAME                                   ,
                        ''                                            ,
                        ''                                            ,
                        ''                                            ,
                        IN_STREET1                                    ,
                        IN_STREET2                                    ,
                        IN_POSTALCODE                                 ,
                        IN_CITY                                       ,
                        ''                                            ,
                        IN_COUNTRYCODE                                ,
                        ''                                            ,
                        IN_PHONE                                      ,
                        ''                                            ,
                        IN_MAIL1                                      ,
                        ''                                            ,
                        ''                                            ,
                        NextCustomerNr                                ,
                        (
                            CASE
                                IN_BIRTHDATE
                            when
                                ''
                            THEN
                                CAST(NULL AS DATE)
                            ELSE
                                CAST(IN_BIRTHDATE AS DATE)
                            END ) ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        (
                            CASE
                                IN_LANGUAGE
                            WHEN
                                'EN'
                            THEN
                                1
                            WHEN
                                'FR'
                            THEN
                                2
                            WHEN
                                'IT'
                            THEN
                                3
                            ELSE
                                0
                            END )          ,
                        ''                 ,
                        ''                 ,
                        0                  ,
                        0                  ,
                        IN_PHONEBUSINESS   ,
                        ''                 ,
                        CAST(NULL AS DATE) ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        0                  ,
                        0                  ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        0                  ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        ''                 ,
                        0                  ,
                        0                  ,
                        ''                 ,
                        0                  ,
                        ''                 ,
                        0                  ,
                        '1'                ,
                        'storedproc'       ,
                        CURRENT DATE       ,
                        'storedproc'       ,
                        CURRENT DATE       ,
                        ''                 ,
                        ''                 ,
                        0                  ,
                        ''                 ,
                        (
                            CASE
                                IN_MAILING
                            WHEN
                                'NO'
                            THEN
                                0
                            ELSE
                                1
                            END ) ,
                        0         ,
                        ''        ,
                        ''        ,
                        0         ,
                        0         ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        0         ,
                        ''        ,
                        ''        ,
                        0         ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        0         ,
                        0         ,
                        ''        ,
                        0         ,
                        0         ,
                        0         ,
                        0         ,
                        0         ,
                        0         ,
                        0         ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        0         ,
                        0         ,
                        ''        ,
                        (
                            CASE
                                IN_TYPE
                            WHEN
                                'AGENT'
                            THEN
                                1
                            ELSE
                                0
                            END ) ,
                        IN_MAIL2  ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        ''        ,
                        (
                            SELECT
                                AN_SEQ
                            FROM
                                DB2ADMIN.ANREDE
                            WHERE
                                UPPER(AN_DEUTSCH)        = UPPER(IN_SALUTATION)
                            AND COALESCE(AN_DEUTSCH, '') <> '' ) ,
                        (
                            SELECT
                                (
                                    CASE
                                        IN_LANGUAGE
                                    WHEN
                                        'EN'
                                    THEN
                                        AN_ENGLISCH
                                    WHEN
                                        'FR'
                                    THEN
                                        AN_FRANZ
                                    WHEN
                                        'IT'
                                    THEN
                                        AN_ITAL
                                    ELSE
                                        AN_DEUTSCH
                                    END )
                            FROM
                                DB2ADMIN.ANREDE
                            WHERE
                                UPPER(AN_DEUTSCH)        = UPPER(IN_SALUTATION)
                            AND COALESCE(AN_DEUTSCH, '') <> '' ) ,
                        IN_TITLE                                 ,
                        ''                                       ,
                        0                                        ,
                        ''                                       ,
                        ''                                       ,
                        ''                                       ,
                        0                                        ,
                        ''                                       ,
                        ''                                       ,
                        ''                                       ,
                        CAST(NULL AS DATE)                       ,
                        0                                        ,
                        0                                        ,
                        ''                                       ,
                        ''                                       ,
                        0                                        ,
                        0                                        ,
                        (
                            CASE
                                IN_TYPE
                            WHEN
                                'B2BCOMPANY'
                            THEN
                                1
                            ELSE
                                0
                            END )
                    )
                ;
                /* INSERT SALESFORCECUSTOMER */
                INSERT INTO "DB2ADMIN"."SALESFORCECUSTOMER"
                    (
                        "PRIMARYKEY"           ,
                        "SALUTATION"           ,
                        "TITLE"                ,
                        "FIRSTNAME"            ,
                        "LASTNAME"             ,
                        "STREET1"              ,
                        "STREET2"              ,
                        "COUNTRYCODE"          ,
                        "POSTALCODE"           ,
                        "CITY"                 ,
                        "PHONE"                ,
                        "PHONEBUSINESS"        ,
                        "MOBILE"               ,
                        "CUSTOMERNR"           ,
                        "BIRTHDATE"            ,
                        "MAIL1"                ,
                        "MAIL2"                ,
                        "LOCKED"               ,
                        "LANGUAGE"             ,
                        "MAILING"              ,
                        "TYPE"                 ,
                        "NROFFILES"            ,
                        "NROFPRINTEDFILES"     ,
                        "NONSMOKER"            ,
                        "SMOKER"               ,
                        "AISLE"                ,
                        "WINDOW"               ,
                        "SPECIALMEALCODE"      ,
                        "SPECIALSEATCODE"      ,
                        "TRAINHALBTAX"         ,
                        "TRAINHALBTAXEXPIRY"   ,
                        "TRAINGA"              ,
                        "TRAINGAEXPIRY"        ,
                        "TRAINNRYEARS"         ,
                        "TRAINCLASS"           ,
                        "PASSPORTNATIONALITY"  ,
                        "PASSPORTBIRTHTOWN"    ,
                        "PASSPORTNUMBER"       ,
                        "PASSPORTVALIDUNTIL"   ,
                        "PASSPORTPLACEOFISSUE" ,
                        "PASSPORTISSUEDATE"    ,
                        "JOB"                  ,
                        "LAST10DESTINATIONS"   ,
                        "MODDATETIME"          ,
                        "MD5"                  ,
                        ACTION                 ,
                        "LOCKEDREASON"         ,
                        "MODDATETIME2"
                    )
                VALUES
                    (
                    (
                        SELECT
                            R_SEQ
                        FROM
                            DB2ADMIN.RECHEMPF
                        WHERE
                            R_KUNDENNBR = NextCustomerNr ) ,
                    IN_SALUTATION                          ,
                    IN_TITLE                               ,
                    IN_FIRSTNAME                           ,
                    IN_LASTNAME                            ,
                    IN_STREET1                             ,
                    IN_STREET2                             ,
                    IN_COUNTRYCODE                         ,
                    IN_POSTALCODE                          ,
                    IN_CITY                                ,
                    IN_PHONE                               ,
                    IN_PHONEBUSINESS                       ,
                    IN_MOBILE                              ,
                    NextCustomerNr                         ,
                    IN_BIRTHDATE                           ,
                    IN_MAIL1                               ,
                    IN_MAIL2                               ,
                    ''                                     ,
                    IN_LANGUAGE                            ,
                    IN_MAILING                             ,
                    IN_TYPE                                ,
                    '0'                                    ,
                    '0'                                    ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    ''                                     ,
                    CAST(CURRENT TIMESTAMP AS CHAR(26))    ,
                    ''                                     ,
                    'INSERT'                               ,
                    ''                                     ,
                    CAST(CURRENT TIMESTAMP AS CHAR(26))
                    )
                ;
                /* Add a JOB to create a DWH Trigger TOUCH_CUSTOMER to update the data in the SALESFORCECUSTOMER table */
                INSERT INTO "DB2ADMIN"."JOB"
                    (
                        "JB_SEQ"         ,
                        "JB_CODE"        ,
                        "JB_TRIGGERTIME" ,
                        "JB_KEY1"        ,
                        "JB_KEY2"        ,
                        "JB_KEY3"        ,
                        "JB_LOCKMINUTES"
                    )
                SELECT
                    NEXTVAL FOR SEQ_JOB                          ,
                    'TOUCH_CUSTOMER'                             ,
                    CURRENT TIMESTAMP                            ,
                    CAST(PREVVAL FOR SEQ_RECHEMPF AS VARCHAR(20)),
                    CAST(NextCustomerNr AS VARCHAR(20))          ,
                    ''                                           ,
                    1
                FROM
                    SYSIBM.SYSDUMMY1
                WHERE NOT EXISTS
                    (
                        SELECT
                            JB_SEQ
                        FROM
                            JOB
                        WHERE
                            JB_CODE   = 'TOUCH_CUSTOMER'
                        and JB_KEY1   = CAST(PREVVAL FOR SEQ_RECHEMPF AS VARCHAR(20))
                        and JB_KEY2   = CAST(NextCustomerNr AS VARCHAR(20))
                        and JB_KEY3   = ''
                        and JB_STATUS = 0 );
            
            ELSEIF
                /* ELSEIF IN_ACTION = 'INSERT' AND LASTNAME = '' */
                IN_ACTION       = 'INSERT'
                AND IN_LASTNAME = ''
            THEN
                SET ErrorCode = 'Missing_INSERT_LASTNAME';
                SET ErrorDesc = 'INSERT with a missing LASTNAME parameter';
            ELSEIF
                /* ELSEIF IN_ACTION = 'UPDATE' AND (IN_CUSTOMER_NR <= 0 OR LASTNAME = '') */
                IN_ACTION            = 'UPDATE'
                AND ( IN_CUSTOMER_NR <= 0
                OR IN_LASTNAME       = '' )
            THEN
                SET ErrorCode = 'Missing_UPDATE_CUSTOMER_NR';
                SET ErrorDesc = 'UPDATE with a missing, 0 or negative IN_CUSTOMER_NR parameter';
            ELSEIF
                /* ELSEIF IN_ACTION = 'UPDATE' AND IN_CUSTOMER_NR > 0 AND LASTNAME <> '' */
                IN_ACTION          = 'UPDATE'
                AND IN_CUSTOMER_NR > 0
                AND IN_LASTNAME    <> ''
            THEN
                SELECT
                    R_SEQ
                INTO
                    Rechempf_Seq
                FROM
                    DB2ADMIN.RECHEMPF
                WHERE
                    R_KUNDENNBR         = IN_CUSTOMER_NR
                AND COALESCE(R_SEQ, '') <> ''
                FETCH FIRST 1 ROW ONLY;
                /* Update the RECHEMPF table. Only those parameters that are passed are updated. */
                UPDATE
                    DB2ADMIN.RECHEMPF
                SET
                    R_ANREDE1         = IN_SALUTATION    ,
                    R_AN_TITEL        = IN_TITLE         ,
                    R_VORNAME1        = IN_FIRSTNAME     ,
                    R_NAME1           = IN_LASTNAME      ,
                    R_STRASSE         = IN_STREET1       ,
                    R_STRASSEZUSATZ   = IN_STREET2       ,
                    R_LAND            = IN_COUNTRYCODE   ,
                    R_PLZ             = IN_POSTALCODE    ,
                    R_ORT             = IN_CITY          ,
                    R_TEL             = IN_PHONE         ,
                    R_TELVOR          = ''               ,
                    R_TELGESCHAEFT    = IN_PHONEBUSINESS ,
                    R_TELGESCHAEFTVOR = ''               ,
                    R_NATEL           = IN_MOBILE        ,
                    R_NATELVOR        = ''               ,
                    R_GEBURTSTAG      = (
                        CASE
                            IN_BIRTHDATE
                        when
                            ''
                        THEN
                            CAST(NULL AS DATE)
                        ELSE
                            CAST(IN_BIRTHDATE AS DATE)
                        END )             ,
                    R_INTERNET  = IN_MAIL1 ,
                    R_ADD_EMAIL = IN_MAIL2 ,
                    R_LANG      = (
                        CASE
                            IN_LANGUAGE
                        WHEN
                            'EN'
                        THEN
                            1
                        WHEN
                            'FR'
                        THEN
                            2
                        WHEN
                            'IT'
                        THEN
                            3
                        ELSE
                            0
                        END ) ,
                    R_NOMAILING = (
                        CASE
                            IN_MAILING
                        WHEN
                            'NO'
                        THEN
                            0
                        ELSE
                            1
                        END ) ,
                    R_AGENT = (
                        CASE
                            IN_TYPE
                        WHEN
                            'AGENT'
                        THEN
                            1
                        ELSE
                            0
                        END ) ,
                    R_ORGANISATION = (
                        CASE
                            IN_TYPE
                        WHEN
                            'B2BCOMPANY'
                        THEN
                            1
                        ELSE
                            0
                        END )
                WHERE
                    R_SEQ = Rechempf_Seq;
                /* Update the SALESFORCECUSTOMER table. Only those parameters that are passed are updated. */
                UPDATE
                    "DB2ADMIN"."SALESFORCECUSTOMER"
                SET
                    SALUTATION    = IN_SALUTATION                       ,
                    TITLE         = IN_TITLE                            ,
                    FIRSTNAME     = IN_FIRSTNAME                        ,
                    LASTNAME      = IN_LASTNAME                         ,
                    STREET1       = IN_STREET1                          ,
                    STREET2       = IN_STREET2                          ,
                    COUNTRYCODE   = IN_COUNTRYCODE                      ,
                    POSTALCODE    = IN_POSTALCODE                       ,
                    CITY          = IN_CITY                             ,
                    PHONE         = IN_PHONE                            ,
                    PHONEBUSINESS = IN_PHONEBUSINESS                    ,
                    MOBILE        = IN_MOBILE                           ,
                    BIRTHDATE     = IN_BIRTHDATE                        ,
                    MAIL1         = IN_MAIL1                            ,
                    MAIL2         = IN_MAIL2                            ,
                    LANGUAGE      = IN_LANGUAGE                         ,
                    MAILING       = IN_MAILING                          ,
                    "TYPE"        = IN_TYPE                             ,
                    MODDATETIME   = CAST(CURRENT TIMESTAMP AS CHAR(26)) ,
                    MD5           = ''                                  ,
                    ACTION        = 'UPDATE'                            ,
                    MODDATETIME2  = CAST(CURRENT TIMESTAMP AS CHAR(26))
                WHERE
                    PRIMARYKEY = Rechempf_Seq;
                /* Add a JOB to create a DWH Trigger TOUCH_CUSTOMER to update the data in the SALESFORCECUSTOMER table */
                INSERT INTO "DB2ADMIN"."JOB"
                    (
                        "JB_SEQ"         ,
                        "JB_CODE"        ,
                        "JB_TRIGGERTIME" ,
                        "JB_KEY1"        ,
                        "JB_KEY2"        ,
                        "JB_KEY3"        ,
                        "JB_LOCKMINUTES"
                    )
                SELECT
                    NEXTVAL FOR SEQ_JOB                 ,
                    'TOUCH_CUSTOMER'                    ,
                    CURRENT TIMESTAMP                   ,
                    Rechempf_Seq                        ,
                    CAST(IN_CUSTOMER_NR AS VARCHAR(20)) ,
                    ''                                  ,
                    1
                FROM
                    SYSIBM.SYSDUMMY1
                WHERE NOT EXISTS
                    (
                        SELECT
                            JB_SEQ
                        FROM
                            JOB
                        WHERE
                            JB_CODE   = 'TOUCH_CUSTOMER'
                        and JB_KEY1   = Rechempf_Seq
                        and JB_KEY2   = CAST(IN_CUSTOMER_NR AS VARCHAR(20))
                        and JB_KEY3   = ''
                        and JB_STATUS = 0 );
            
            ELSEIF
                /* ELSEIF IN_ACTION = 'GET' AND IN_CUSTOMER_NR <= 0 */
                IN_ACTION          = 'GET'
                AND IN_CUSTOMER_NR <= 0
            THEN
                SET ErrorCode = 'Missing_GET_CUSTOMER_NR';
                SET ErrorDesc = 'GET with a missing, 0 or negative IN_CUSTOMER_NR parameter';
            END IF;
            /* Cursor left open for client application */
            IF
                ErrorCode = ''
            THEN
                OPEN cursor1;
            ELSE
                OPEN errorcursor1;
            END IF;
        END
    P1 @

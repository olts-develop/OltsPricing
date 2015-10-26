
alter table TOODESCRIPTIONS     alter ID set cache 1000 @
alter table TOOPERDAYPRICE      alter ID set cache 1000 @
alter table TOOADDPERDAYPRICE   alter ID set cache 1000 @
alter table TOOONETIME          alter ID set cache 1000 @
alter table TOOSPECIALOFFERS    alter ID set cache 1000 @
alter table TOOEARLYBOOKINGS    alter ID set cache 1000 @
alter table TOOALLOTMENTS       alter ID set cache 1000 @
alter table TOOCANCELLATIONS    alter ID set cache 1000 @
alter table TOOITEMINFOS        alter ID set cache 1000 @
alter table TOOPERIODPRICE      alter ID set cache 1000 @
alter table TOOADDPERIODPRICE   alter ID set cache 1000 @
alter table TOOMISCHOTEL        alter ID set cache 1000 @
alter table TOOMISCTEXT         alter ID set cache 1000 @


-- REPLACE löscht alle Daten in der Tabelle vor dem Import
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooHotels.csv"           OF DEL MODIFIED BY norowwarnings   REPLACE INTO TOOHOTEL' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooRooms_c.csv"          OF DEL                             REPLACE INTO TOOROOMS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooMisc.csv"             OF DEL                             REPLACE INTO TOOMISC' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooMiscHotel.csv"        OF DEL                             REPLACE INTO TOOMISCHOTEL' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooMiscText.csv"         OF DEL                             REPLACE INTO TOOMISCTEXT' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooDescriptions.csv"     OF DEL MODIFIED BY identitymissing REPLACE INTO TOODESCRIPTIONS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooPerDayPrices.csv"     OF DEL MODIFIED BY identitymissing REPLACE INTO TOOPERDAYPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooAddPerDayPrices.csv"  OF DEL MODIFIED BY identitymissing REPLACE INTO TOOADDPERDAYPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooOneTimes.csv"         OF DEL MODIFIED BY identitymissing REPLACE INTO TOOONETIME' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooSpecialOffers.csv"    OF DEL MODIFIED BY identitymissing REPLACE INTO TOOSPECIALOFFERS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooEarlyBookings.csv"    OF DEL MODIFIED BY identitymissing REPLACE INTO TOOEARLYBOOKINGS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooAllotments.csv"       OF DEL MODIFIED BY identitymissing REPLACE INTO TOOALLOTMENTS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooCancellations.csv"    OF DEL MODIFIED BY identitymissing REPLACE INTO TOOCANCELLATIONS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooItemInfos.csv"        OF DEL MODIFIED BY identitymissing REPLACE INTO TOOITEMINFOS' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooPeriodPrices.csv"     OF DEL MODIFIED BY identitymissing REPLACE INTO TOOPERIODPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'LOAD FROM "C:\dev\github\OltsPricing\sql\import\tooAddPeriodPrices.csv"  OF DEL MODIFIED BY identitymissing REPLACE INTO TOOADDPERIODPRICE' ) @


alter table TOODESCRIPTIONS      alter ID set no cache @
alter table TOOPERDAYPRICE       alter ID set no cache @
alter table TOOADDPERDAYPRICE    alter ID set no cache @
alter table TOOONETIME           alter ID set no cache @
alter table TOOSPECIALOFFERS     alter ID set no cache @
alter table TOOEARLYBOOKINGS     alter ID set no cache @
alter table TOOALLOTMENTS        alter ID set no cache @
alter table TOOCANCELLATIONS     alter ID set no cache @
alter table TOOITEMINFOS         alter ID set no cache @
alter table TOOPERIODPRICE       alter ID set no cache @
alter table TOOADDPERIODPRICE    alter ID set no cache @
alter table TOOMISCHOTEL         alter ID set no cache @
alter table TOOMISCTEXT          alter ID set no cache @

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

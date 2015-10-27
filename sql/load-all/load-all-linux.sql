
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
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooRooms.csv"           OF DEL                             REPLACE INTO TOOROOMS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooMisc.csv"            OF DEL                             REPLACE INTO TOOMISC @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooMiscHotel.csv"       OF DEL MODIFIED BY identitymissing REPLACE INTO TOOMISCHOTEL @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooMiscText.csv"        OF DEL MODIFIED BY identitymissing REPLACE INTO TOOMISCTEXT @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooDescriptions.csv"    OF DEL MODIFIED BY identitymissing REPLACE INTO TOODESCRIPTIONS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooPerDayPrices.csv"    OF DEL MODIFIED BY identitymissing REPLACE INTO TOOPERDAYPRICE @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooAddPerDayPrices.csv" OF DEL MODIFIED BY identitymissing REPLACE INTO TOOADDPERDAYPRICE @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooOneTimes.csv"        OF DEL MODIFIED BY identitymissing REPLACE INTO TOOONETIME @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooSpecialOffers.csv"   OF DEL MODIFIED BY identitymissing REPLACE INTO TOOSPECIALOFFERS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooEarlyBookings.csv"   OF DEL MODIFIED BY identitymissing REPLACE INTO TOOEARLYBOOKINGS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooAllotments.csv"      OF DEL MODIFIED BY identitymissing REPLACE INTO TOOALLOTMENTS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooCancellations.csv"   OF DEL MODIFIED BY identitymissing REPLACE INTO TOOCANCELLATIONS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooItemInfos.csv"       OF DEL MODIFIED BY identitymissing REPLACE INTO TOOITEMINFOS @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooPeriodPrices.csv"    OF DEL MODIFIED BY identitymissing REPLACE INTO TOOPERIODPRICE @
LOAD CLIENT FROM "/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/import/tooAddPeriodPrices.csv" OF DEL MODIFIED BY identitymissing REPLACE INTO TOOADDPERIODPRICE @
-- Important: the tooHotels.csv can, and normally does, contain duplicated data. A LOAD will result in duplicate data.
-- It is *very* important to use the IMPORT here, as this will ignore duplicates.                                              
IMPORT      FROM "../import/tooHotels.csv"  OF DEL MODIFIED BY norowwarnings COMMITCOUNT 100000 REPLACE INTO TOOHOTEL @


alter table TOODESCRIPTIONS     alter ID set no cache @
alter table TOOPERDAYPRICE      alter ID set no cache @
alter table TOOADDPERDAYPRICE   alter ID set no cache @
alter table TOOONETIME          alter ID set no cache @
alter table TOOSPECIALOFFERS    alter ID set no cache @
alter table TOOEARLYBOOKINGS    alter ID set no cache @
alter table TOOALLOTMENTS       alter ID set no cache @
alter table TOOCANCELLATIONS    alter ID set no cache @
alter table TOOITEMINFOS        alter ID set no cache @
alter table TOOPERIODPRICE      alter ID set no cache @
alter table TOOADDPERIODPRICE   alter ID set no cache @
alter table TOOMISCHOTEL        alter ID set no cache @
alter table TOOMISCTEXT         alter ID set no cache @

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------


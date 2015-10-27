
-- REPLACE löscht alle Daten in der Tabelle vor dem Import
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooHotels.csv"   OF DEL MODIFIED BY norowwarnings METHOD P ( 1, 33 ) COMMITCOUNT 10000  REPLACE INTO TOOHOTEL2 ( HOTELKEY, TOCODE )' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooRooms_c.csv"  OF DEL                           METHOD P ( 2, 29 ) COMMITCOUNT 10000  REPLACE INTO TOOROOMS2 ( ROOMKEY, TOCODE )' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooMisc.csv"     OF DEL                           METHOD P ( 1, 2 )  COMMITCOUNT 10000  REPLACE INTO TOOMISC2 ( MISCKEY, TOCODE )' ) @


delete from TOOHOTEL           where (TOOHOTEL.HOTELKEY, TOOHOTEL.TOCODE)                  in (select TOOHOTEL2.HOTELKEY, TOOHOTEL2.TOCODE from TOOHOTEL2) @
delete from TOOROOMS           where (TOOROOMS.ROOMKEY, TOOROOMS.TOCODE)                   in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) @
delete from TOOMISC            where (TOOMISC.MISCKEY, TOOMISC.TOCODE)                     in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) @
delete from TOOMISCHOTEL       where (TOOMISCHOTEL.MISCKEY, TOOMISCHOTEL.TOCODE)           in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) @
delete from TOOMISCTEXT        where (TOOMISCTEXT.MISCKEY, TOOMISCTEXT.TOCODE)             in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) @

delete from TOODESCRIPTIONS    where (TOODESCRIPTIONS.ITEMKEY, TOODESCRIPTIONS.TOCODE)     in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOPERDAYPRICE     where (TOOPERDAYPRICE.ITEMKEY, TOOPERDAYPRICE.TOCODE)       in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOADDPERDAYPRICE  where (TOOADDPERDAYPRICE.ITEMKEY, TOOADDPERDAYPRICE.TOCODE) in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOONETIME         where (TOOONETIME.ITEMKEY, TOOONETIME.TOCODE)               in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOSPECIALOFFERS   where (TOOSPECIALOFFERS.ITEMKEY, TOOSPECIALOFFERS.TOCODE)   in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOEARLYBOOKINGS   where (TOOEARLYBOOKINGS.ITEMKEY, TOOEARLYBOOKINGS.TOCODE)   in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOALLOTMENTS      where (TOOALLOTMENTS.ITEMKEY, TOOALLOTMENTS.TOCODE)         in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOCANCELLATIONS   where (TOOCANCELLATIONS.ITEMKEY, TOOCANCELLATIONS.TOCODE)   in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOITEMINFOS       where (TOOITEMINFOS.ITEMKEY, TOOITEMINFOS.TOCODE)           in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOPERIODPRICE     where (TOOPERIODPRICE.ITEMKEY, TOOPERIODPRICE.TOCODE)       in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOADDPERIODPRICE  where (TOOADDPERIODPRICE.ITEMKEY, TOOADDPERIODPRICE.TOCODE) in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) and TOODESCRIPTIONS.ITEMTYPE   ='H' @


delete from TOODESCRIPTIONS    where (TOODESCRIPTIONS.ITEMKEY, TOODESCRIPTIONS.TOCODE)     in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOPERDAYPRICE     where (TOOPERDAYPRICE.ITEMKEY, TOOPERDAYPRICE.TOCODE)       in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOADDPERDAYPRICE  where (TOOADDPERDAYPRICE.ITEMKEY, TOOADDPERDAYPRICE.TOCODE) in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOONETIME         where (TOOONETIME.ITEMKEY, TOOONETIME.TOCODE)               in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOSPECIALOFFERS   where (TOOSPECIALOFFERS.ITEMKEY, TOOSPECIALOFFERS.TOCODE)   in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOEARLYBOOKINGS   where (TOOEARLYBOOKINGS.ITEMKEY, TOOEARLYBOOKINGS.TOCODE)   in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOALLOTMENTS      where (TOOALLOTMENTS.ITEMKEY, TOOALLOTMENTS.TOCODE)         in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOCANCELLATIONS   where (TOOCANCELLATIONS.ITEMKEY, TOOCANCELLATIONS.TOCODE)   in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOITEMINFOS       where (TOOITEMINFOS.ITEMKEY, TOOITEMINFOS.TOCODE)           in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOPERIODPRICE     where (TOOPERIODPRICE.ITEMKEY, TOOPERIODPRICE.TOCODE)       in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOADDPERIODPRICE  where (TOOADDPERIODPRICE.ITEMKEY, TOOADDPERIODPRICE.TOCODE) in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) and TOODESCRIPTIONS.ITEMTYPE   ='M' @        



alter table TOODESCRIPTIONS      alter ID set cache 20 @
alter table TOOPERDAYPRICE       alter ID set cache 20 @
alter table TOOADDPERDAYPRICE    alter ID set cache 20 @
alter table TOOONETIME           alter ID set cache 20 @
alter table TOOSPECIALOFFERS     alter ID set cache 20 @
alter table TOOEARLYBOOKINGS     alter ID set cache 20 @
alter table TOOALLOTMENTS        alter ID set cache 20 @
alter table TOOCANCELLATIONS     alter ID set cache 20 @
alter table TOOITEMINFOS         alter ID set cache 20 @
alter table TOOPERIODPRICE       alter ID set cache 20 @
alter table TOOADDPERIODPRICE    alter ID set cache 20 @
alter table TOOMISCHOTEL         alter ID set cache 20 @
alter table TOOMISCTEXT          alter ID set cache 20 @


-- INSERT fügt nur die neuen Daten hinzu. Da die Daten oben gelöscht wurden führt dies zu keinen Konflikten.
-- Am Besten wäre wenn der DELETE in einer Transaktion wäre, und bei einem Problem gibt es ein ROLLBACK.
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooRooms.csv"           OF DEL                             COMMITCOUNT 10000 INSERT INTO TOOROOMS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooMisc.csv"            OF DEL                             COMMITCOUNT 10000 INSERT INTO TOOMISC' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooMiscHotel.csv"       OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOMISCHOTEL' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooMiscText.csv"        OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOMISCTEXT' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooDescriptions.csv"    OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOODESCRIPTIONS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooPerDayPrices.csv"    OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOPERDAYPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooAddPerDayPrices.csv" OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOADDPERDAYPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooOneTimes.csv"        OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOONETIME' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooSpecialOffers.csv"   OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOSPECIALOFFERS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooEarlyBookings.csv"   OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOEARLYBOOKINGS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooAllotments.csv"      OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOALLOTMENTS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooCancellations.csv"   OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOCANCELLATIONS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooItemInfos.csv"       OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOITEMINFOS' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooPeriodPrices.csv"    OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOPERIODPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooAddPeriodPrices.csv" OF DEL MODIFIED BY identitymissing COMMITCOUNT 10000 INSERT INTO TOOADDPERIODPRICE' ) @
CALL SYSPROC.ADMIN_CMD( 'IMPORT FROM "C:\dev\github\OltsPricing\sql\import\tooHotels.csv"          OF DEL MODIFIED BY norowwarnings   COMMITCOUNT 10000 INSERT INTO TOOHOTEL' ) @


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


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
IMPORT FROM ../import/tooRooms.csv            OF DEL                             COMMITCOUNT 100000 REPLACE INTO TOOROOMS @
IMPORT FROM ../import/tooMisc.csv             OF DEL                             COMMITCOUNT 100000 REPLACE INTO TOOMISC @
IMPORT FROM ../import/tooMiscHotel.csv        OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOMISCHOTEL @
IMPORT FROM ../import/tooMiscText.csv         OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOMISCTEXT @
IMPORT FROM ../import/tooDescriptions.csv     OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOODESCRIPTIONS @
IMPORT FROM ../import/tooPerDayPrices.csv     OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOPERDAYPRICE @
IMPORT FROM ../import/tooAddPerDayPrices.csv  OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOADDPERDAYPRICE @
IMPORT FROM ../import/tooOneTimes.csv         OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOONETIME @
IMPORT FROM ../import/tooSpecialOffers.csv    OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOSPECIALOFFERS @
IMPORT FROM ../import/tooEarlyBookings.csv    OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOEARLYBOOKINGS @
IMPORT FROM ../import/tooAllotments.csv       OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOALLOTMENTS @
IMPORT FROM ../import/tooCancellations.csv    OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOCANCELLATIONS @
IMPORT FROM ../import/tooItemInfos.csv        OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOITEMINFOS @
IMPORT FROM ../import/tooPeriodPrices.csv     OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOPERIODPRICE @
IMPORT FROM ../import/tooAddPeriodPrices.csv  OF DEL MODIFIED BY identitymissing COMMITCOUNT 100000 REPLACE INTO TOOADDPERIODPRICE @
IMPORT FROM ../import/tooHotels.csv           OF DEL MODIFIED BY norowwarnings   COMMITCOUNT 100000 REPLACE INTO TOOHOTEL @


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

update TOODESCRIPTIONS   set itemtype='H' where coalesce(itemtype,'')='' @
update TOOPERDAYPRICE    set itemtype='H' where coalesce(itemtype,'')='' @
update TOOADDPERDAYPRICE set itemtype='H' where coalesce(itemtype,'')='' @
update TOOONETIME        set itemtype='H' where coalesce(itemtype,'')='' @
update TOOSPECIALOFFERS  set itemtype='H' where coalesce(itemtype,'')='' @
update TOOEARLYBOOKINGS  set itemtype='H' where coalesce(itemtype,'')='' @
update TOOALLOTMENTS     set itemtype='H' where coalesce(itemtype,'')='' @
update TOOCANCELLATIONS  set itemtype='H' where coalesce(itemtype,'')='' @
update TOOITEMINFOS      set itemtype='H' where coalesce(itemtype,'')='' @
update TOOPERIODPRICE    set itemtype='H' where coalesce(itemtype,'')='' @
update TOOADDPERIODPRICE set itemtype='H' where coalesce(itemtype,'')='' @

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------

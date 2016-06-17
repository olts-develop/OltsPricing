
-- REPLACE löscht alle Daten in der Tabelle vor dem Import
IMPORT FROM ../import/tooHotels.csv    OF DEL MODIFIED BY norowwarnings METHOD P ( 1, 33 ) COMMITCOUNT 10000  REPLACE INTO TOOHOTEL2 ( HOTELKEY, TOCODE ) @
IMPORT FROM ../import/tooRooms.csv     OF DEL                           METHOD P ( 2, 29 ) COMMITCOUNT 10000  REPLACE INTO TOOROOMS2 ( ROOMKEY, TOCODE ) @
IMPORT FROM ../import/tooMisc.csv      OF DEL                           METHOD P ( 1, 2 )  COMMITCOUNT 10000  REPLACE INTO TOOMISC2  ( MISCKEY, TOCODE ) @


delete from TOOHOTEL where (TOOHOTEL.HOTELKEY, TOOHOTEL.TOCODE)                           in (select TOOHOTEL2.HOTELKEY, TOOHOTEL2.TOCODE from TOOHOTEL2) @
delete from TOOROOMS where (TOOROOMS.ROOMKEY, TOOROOMS.TOCODE)                            in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2) @
delete from TOOMISC where (TOOMISC.MISCKEY, TOOMISC.TOCODE)                               in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) @
delete from TOOMISCHOTEL where (TOOMISCHOTEL.MISCKEY, TOOMISCHOTEL.TOCODE)                in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) @
delete from TOOMISCTEXT where (TOOMISCTEXT.MISCKEY, TOOMISCTEXT.TOCODE)                   in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2) @

delete from TOODESCRIPTIONS where (TOODESCRIPTIONS.ITEMKEY, TOODESCRIPTIONS.TOCODE)       in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOODESCRIPTIONS.ITEMTYPE   ='H' @
delete from TOOPERDAYPRICE where (TOOPERDAYPRICE.ITEMKEY, TOOPERDAYPRICE.TOCODE)          in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOPERDAYPRICE.ITEMTYPE    ='H' @
delete from TOOADDPERDAYPRICE where (TOOADDPERDAYPRICE.ITEMKEY, TOOADDPERDAYPRICE.TOCODE) in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOADDPERDAYPRICE.ITEMTYPE ='H' @
delete from TOOONETIME where (TOOONETIME.ITEMKEY, TOOONETIME.TOCODE)                      in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOONETIME.ITEMTYPE        ='H' @
delete from TOOSPECIALOFFERS where (TOOSPECIALOFFERS.ITEMKEY, TOOSPECIALOFFERS.TOCODE)    in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOSPECIALOFFERS.ITEMTYPE  ='H' @
delete from TOOEARLYBOOKINGS where (TOOEARLYBOOKINGS.ITEMKEY, TOOEARLYBOOKINGS.TOCODE)    in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOEARLYBOOKINGS.ITEMTYPE  ='H' @
delete from TOOALLOTMENTS where (TOOALLOTMENTS.ITEMKEY, TOOALLOTMENTS.TOCODE)             in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOALLOTMENTS.ITEMTYPE     ='H' @
delete from TOOCANCELLATIONS where (TOOCANCELLATIONS.ITEMKEY, TOOCANCELLATIONS.TOCODE)    in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOCANCELLATIONS.ITEMTYPE  ='H' @
delete from TOOITEMINFOS where (TOOITEMINFOS.ITEMKEY, TOOITEMINFOS.TOCODE)                in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOITEMINFOS.ITEMTYPE      ='H' @
delete from TOOPERIODPRICE where (TOOPERIODPRICE.ITEMKEY, TOOPERIODPRICE.TOCODE)          in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOPERIODPRICE.ITEMTYPE    ='H' @
delete from TOOADDPERIODPRICE where (TOOADDPERIODPRICE.ITEMKEY, TOOADDPERIODPRICE.TOCODE) in (select TOOROOMS2.ROOMKEY, TOOROOMS2.TOCODE from TOOROOMS2)   and TOOADDPERIODPRICE.ITEMTYPE ='H' @
                                                                                                                                                           
delete from TOODESCRIPTIONS where (TOODESCRIPTIONS.ITEMKEY, TOODESCRIPTIONS.TOCODE)       in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOODESCRIPTIONS.ITEMTYPE   ='M' @
delete from TOOPERDAYPRICE where (TOOPERDAYPRICE.ITEMKEY, TOOPERDAYPRICE.TOCODE)          in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOPERDAYPRICE.ITEMTYPE    ='M' @
delete from TOOADDPERDAYPRICE where (TOOADDPERDAYPRICE.ITEMKEY, TOOADDPERDAYPRICE.TOCODE) in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOADDPERDAYPRICE.ITEMTYPE ='M' @
delete from TOOONETIME where (TOOONETIME.ITEMKEY, TOOONETIME.TOCODE)                      in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOONETIME.ITEMTYPE        ='H' @
delete from TOOSPECIALOFFERS where (TOOSPECIALOFFERS.ITEMKEY, TOOSPECIALOFFERS.TOCODE)    in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOSPECIALOFFERS.ITEMTYPE  ='M' @
delete from TOOEARLYBOOKINGS where (TOOEARLYBOOKINGS.ITEMKEY, TOOEARLYBOOKINGS.TOCODE)    in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOEARLYBOOKINGS.ITEMTYPE  ='M' @
delete from TOOALLOTMENTS where (TOOALLOTMENTS.ITEMKEY, TOOALLOTMENTS.TOCODE)             in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOALLOTMENTS.ITEMTYPE     ='M' @
delete from TOOCANCELLATIONS where (TOOCANCELLATIONS.ITEMKEY, TOOCANCELLATIONS.TOCODE)    in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOCANCELLATIONS.ITEMTYPE  ='M' @
delete from TOOITEMINFOS where (TOOITEMINFOS.ITEMKEY, TOOITEMINFOS.TOCODE)                in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOITEMINFOS.ITEMTYPE      ='M' @
delete from TOOPERIODPRICE where (TOOPERIODPRICE.ITEMKEY, TOOPERIODPRICE.TOCODE)          in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)     and TOOPERIODPRICE.ITEMTYPE     ='M' @
delete from TOOADDPERIODPRICE where (TOOADDPERIODPRICE.ITEMKEY, TOOADDPERIODPRICE.TOCODE) in (select TOOMISC2.MISCKEY, TOOMISC2.TOCODE from TOOMISC2)      and TOOADDPERIODPRICE.ITEMTYPE ='M' @


alter table TOODESCRIPTIONS     alter ID set cache 20 @
alter table TOOPERDAYPRICE      alter ID set cache 20 @
alter table TOOADDPERDAYPRICE   alter ID set cache 20 @
alter table TOOONETIME          alter ID set cache 20 @
alter table TOOSPECIALOFFERS    alter ID set cache 20 @
alter table TOOEARLYBOOKINGS    alter ID set cache 20 @
alter table TOOALLOTMENTS       alter ID set cache 20 @
alter table TOOCANCELLATIONS    alter ID set cache 20 @
alter table TOOITEMINFOS        alter ID set cache 20 @
alter table TOOPERIODPRICE      alter ID set cache 20 @
alter table TOOADDPERIODPRICE   alter ID set cache 20 @
alter table TOOMISCHOTEL        alter ID set cache 20 @
alter table TOOMISCTEXT         alter ID set cache 20 @


-- INSERT fügt nur die neuen Daten hinzu. Da die Daten oben gelöscht wurden führt dies zu keinen Konflikten.
-- Am Besten wäre wenn der DELETE in einer Transaktion wäre, und bei einem Problem gibt es ein ROLLBACK.
IMPORT FROM ../import/tooRooms.csv           OF DEL                                              COMMITCOUNT 10000   INSERT INTO TOOROOMS @
IMPORT FROM ../import/tooMisc.csv            OF DEL                                              COMMITCOUNT 10000   INSERT INTO TOOMISC @
IMPORT FROM ../import/tooMiscHotel.csv       OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOMISCHOTEL @
IMPORT FROM ../import/tooMiscText.csv        OF DEL MODIFIED BY identitymissing delprioritychar  COMMITCOUNT 10000   INSERT INTO TOOMISCTEXT @
IMPORT FROM ../import/tooDescriptions.csv    OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOODESCRIPTIONS @
IMPORT FROM ../import/tooPerDayPrices.csv    OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOPERDAYPRICE @
IMPORT FROM ../import/tooAddPerDayPrices.csv OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOADDPERDAYPRICE @
IMPORT FROM ../import/tooOneTimes.csv        OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOONETIME @
IMPORT FROM ../import/tooSpecialOffers.csv   OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOSPECIALOFFERS @
IMPORT FROM ../import/tooEarlyBookings.csv   OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOEARLYBOOKINGS @
IMPORT FROM ../import/tooAllotments.csv      OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOALLOTMENTS @
IMPORT FROM ../import/tooCancellations.csv   OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOCANCELLATIONS @
IMPORT FROM ../import/tooItemInfos.csv       OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOITEMINFOS @
IMPORT FROM ../import/tooPeriodPrices.csv    OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOPERIODPRICE @
IMPORT FROM ../import/tooAddPeriodPrices.csv OF DEL MODIFIED BY identitymissing                  COMMITCOUNT 10000   INSERT INTO TOOADDPERIODPRICE @
IMPORT FROM ../import/tooHotels.csv          OF DEL MODIFIED BY norowwarnings                    COMMITCOUNT 10000   INSERT INTO TOOHOTEL @


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

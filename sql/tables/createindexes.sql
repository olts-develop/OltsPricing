
drop index TOO_HOTEL_IDX1 @
drop index TOO_HOTEL_IDX2 @

drop index TOO_HOTEL2_IDX1 @

drop index TOO_ROOMS_IDX1 @
drop index TOO_ROOMS_IDX2 @
drop index TOO_ROOMS_IDX3 @
drop index TOO_ROOMS_IDX4 @

drop index TOO_ROOMS2_IDX1 @

drop index TOO_DESCS_IDX1 @
drop index TOO_DESCS_IDX2 @
drop index TOO_DESCS_IDX3 @
drop index TOO_DESCS_IDX4 @
drop index TOO_DESCS_IDX5 @
drop index TOO_DESCS_IDX6 @

drop index TOO_PDP_IDX1 @
drop index TOO_PDP_IDX2 @
drop index TOO_PDP_IDX3 @
drop index TOO_PDP_IDX4 @
drop index TOO_PDP_IDX5 @

drop index TOO_APDP_IDX1 @
drop index TOO_APDP_IDX2 @
drop index TOO_APDP_IDX3 @
drop index TOO_APDP_IDX4 @
drop index TOO_APDP_IDX5 @

drop index TOO_OT_IDX1 @
drop index TOO_OT_IDX2 @
drop index TOO_OT_IDX3 @
drop index TOO_OT_IDX4 @
drop index TOO_OT_IDX5 @

drop index TOO_SO_IDX1 @
drop index TOO_SO_IDX2 @
drop index TOO_SO_IDX3 @
drop index TOO_SO_IDX4 @
drop index TOO_SO_IDX5 @

drop index TOO_EB_IDX1 @
drop index TOO_EB_IDX2 @
drop index TOO_EB_IDX3 @
drop index TOO_EB_IDX4 @
drop index TOO_EB_IDX5 @

drop index TOO_ALLOT_IDX1 @
drop index TOO_ALLOT_IDX2 @
drop index TOO_ALLOT_IDX3 @
drop index TOO_ALLOT_IDX4 @

drop index TOO_CANC_IDX1 @
drop index TOO_CANC_IDX2 @
drop index TOO_CANC_IDX3 @
drop index TOO_CANC_IDX4 @

drop index TOO_ITEMINFO_IDX1 @
drop index TOO_ITEMINFO_IDX2 @
drop index TOO_ITEMINFO_IDX3 @
drop index TOO_ITEMINFO_IDX4 @

drop index TOO_PP_IDX1 @
drop index TOO_PP_IDX2 @
drop index TOO_PP_IDX3 @
drop index TOO_PP_IDX4 @
drop index TOO_PP_IDX5 @

drop index TOO_APP_IDX1 @
drop index TOO_APP_IDX2 @
drop index TOO_APP_IDX3 @
drop index TOO_APP_IDX4 @
drop index TOO_APP_IDX5 @

drop index TOO_MISC_IDX1 @

drop index TOO_MISC2_IDX1 @

drop index TOO_MISCHOTEL_IDX1 @
drop index TOO_MISCHOTEL_IDX2 @

drop index TOO_MISCTEXT_IDX1 @

drop index TOO_ARRANGEMENT_IDX1 @

drop index TOO_ARRANGEMENT2_IDX1 @

drop index TOO_FLIGHT_IDX1 @
drop index TOO_FLIGHT_IDX2 @
drop index TOO_FLIGHT_IDX3 @

drop index TOO_FLIGHTLEG_IDX1 @
drop index TOO_FLIGHTLEG_IDX2 @
drop index TOO_FLIGHTLEG_IDX3 @
drop index TOO_FLIGHTLEG_IDX4 @


create index TOO_HOTEL_IDX1 ON TOOHOTEL ( hotelkey, tocode, destinationcode ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_HOTEL_IDX2 ON TOOHOTEL ( hotelkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_HOTEL2_IDX1 ON TOOHOTEL2 ( hotelkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_ROOMS_IDX1 ON TOOROOMS ( hotelkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_ROOMS_IDX2 ON TOOROOMS ( hotelkey, roomkey, tocode ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_ROOMS_IDX3 ON TOOROOMS ( hotelkey, roomkey, tocode, normaloccupancy, extrabedadults, extrabedchildren ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_ROOMS_IDX4 ON TOOROOMS ( roomkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_ROOMS2_IDX1 ON TOOROOMS2 ( roomkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_DESCS_IDX1 ON TOODESCRIPTIONS ( itemkey, tocode, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_DESCS_IDX2 ON TOODESCRIPTIONS ( descid, tocode, itemtype  ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_DESCS_IDX3 ON TOODESCRIPTIONS ( itemkey, tocode, descid, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_DESCS_IDX4 ON TOODESCRIPTIONS ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_DESCS_IDX5 ON TOODESCRIPTIONS ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_DESCS_IDX6 ON TOODESCRIPTIONS ( descid ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_PDP_IDX1 ON TOOPERDAYPRICE ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PDP_IDX2 ON TOOPERDAYPRICE ( itemkey, tocode, day, childidxnr, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PDP_IDX3 ON TOOPERDAYPRICE ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PDP_IDX4 ON TOOPERDAYPRICE ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PDP_IDX5 ON TOOPERDAYPRICE ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_APDP_IDX1 ON TOOADDPERDAYPRICE ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APDP_IDX2 ON TOOADDPERDAYPRICE ( itemkey, tocode, day, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APDP_IDX3 ON TOOADDPERDAYPRICE ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APDP_IDX4 ON TOOADDPERDAYPRICE ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APDP_IDX5 ON TOOADDPERDAYPRICE ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_OT_IDX1 ON TOOONETIME ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_OT_IDX2 ON TOOONETIME ( itemkey, tocode, datefrom, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_OT_IDX3 ON TOOONETIME ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_OT_IDX4 ON TOOONETIME ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_OT_IDX5 ON TOOONETIME ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_SO_IDX1 ON TOOSPECIALOFFERS ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_SO_IDX2 ON TOOSPECIALOFFERS ( itemkey, tocode, datefrom, dateto, childchildnr, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_SO_IDX3 ON TOOSPECIALOFFERS ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_SO_IDX4 ON TOOSPECIALOFFERS ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_SO_IDX5 ON TOOSPECIALOFFERS ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_EB_IDX1 ON TOOEARLYBOOKINGS ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_EB_IDX2 ON TOOEARLYBOOKINGS ( itemkey, tocode, datefrom, dateto, daysbeforedeparturefrom, daysbeforedepartureto, datebeforedeparturefrom, datebeforedepartureto, fromday, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_EB_IDX3 ON TOOEARLYBOOKINGS ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_EB_IDX4 ON TOOEARLYBOOKINGS ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_EB_IDX5 ON TOOEARLYBOOKINGS ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_ALLOT_IDX1 ON TOOALLOTMENTS ( itemkey, tocode, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_ALLOT_IDX2 ON TOOALLOTMENTS ( itemkey, tocode, allotdate, rel, minstay, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_ALLOT_IDX3 ON TOOALLOTMENTS ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_ALLOT_IDX4 ON TOOALLOTMENTS ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_CANC_IDX1 ON TOOCANCELLATIONS ( itemkey, tocode, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_CANC_IDX2 ON TOOCANCELLATIONS ( itemkey, tocode, begindate, enddate, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_CANC_IDX3 ON TOOCANCELLATIONS ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_CANC_IDX4 ON TOOCANCELLATIONS ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_ITEMINFO_IDX1 ON TOOITEMINFOS ( itemkey, tocode, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_ITEMINFO_IDX2 ON TOOITEMINFOS ( itemkey, tocode, begindate, enddate, itemtype ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_ITEMINFO_IDX3 ON TOOITEMINFOS ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_ITEMINFO_IDX4 ON TOOITEMINFOS ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_PP_IDX1 ON TOOPERIODPRICE ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PP_IDX2 ON TOOPERIODPRICE ( itemkey, tocode, datefrom, dateto, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PP_IDX3 ON TOOPERIODPRICE ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PP_IDX4 ON TOOPERIODPRICE ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_PP_IDX5 ON TOOPERIODPRICE ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_APP_IDX1 ON TOOADDPERIODPRICE ( itemkey, tocode, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APP_IDX2 ON TOOADDPERIODPRICE ( itemkey, tocode, datefrom, dateto, itemtype, currency ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APP_IDX3 ON TOOADDPERIODPRICE ( itemkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APP_IDX4 ON TOOADDPERIODPRICE ( parentkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create index TOO_APP_IDX5 ON TOOADDPERIODPRICE ( p_seq ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_MISC_IDX1 ON TOOMISC ( misckey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_MISC2_IDX1 ON TOOMISC2 ( misckey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create  index TOO_MISCHOTEL_IDX1 on TOOMISCHOTEL (misckey asc)  ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @
create  index TOO_MISCHOTEL_IDX2 on TOOMISCHOTEL (hotelkey asc)  ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create  index TOO_MISCTEXT_IDX1 on TOOMISCTEXT (misckey asc)  ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO   @

create index TOO_ARRANGEMENT_IDX1 ON TOOARRANGEMENT ( arrkey, tocode ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_ARRANGEMENT_IDX2 ON TOOARRANGEMENT ( arrkey, tocode, normaloccupancy, extrabedadults, extrabedchildren ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_ARRANGEMENT_IDX3 ON TOOARRANGEMENT ( arrkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_ARRANGEMENT2_IDX1 ON TOOARRANGEMENT2 ( arrkey ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_FLIGHT_IDX1 ON TOOFLIGHT ( FLIGHTKEY ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_FLIGHT_IDX2 ON TOOFLIGHT ( DEP, ARR, TOCODE ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_FLIGHT_IDX3 ON TOOFLIGHT ( FLIGHTKEY, TOCODE ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @

create index TOO_FLIGHTLEG_IDX1 ON TOOFLIGHTLEG ( LEGKEY ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_FLIGHTLEG_IDX2 ON TOOFLIGHTLEG ( FLIGHTKEY ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_FLIGHTLEG_IDX3 ON TOOFLIGHTLEG ( FLIGHTKEY, TOCODE ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @
create index TOO_FLIGHTLEG_IDX4 ON TOOFLIGHTLEG ( LEGKEY, TOCODE ) ALLOW REVERSE SCANS PAGE SPLIT SYMMETRIC COMPRESS NO  @






CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOHOTEL UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOHOTEL ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOROOMS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOROOMS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOODESCRIPTIONS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOODESCRIPTIONS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOPERDAYPRICE UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOPERDAYPRICE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOADDPERDAYPRICE UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOADDPERDAYPRICE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOONETIME UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOONETIME ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOSPECIALOFFERS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOSPECIALOFFERS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOEARLYBOOKINGS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOEARLYBOOKINGS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOALLOTMENTS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOALLOTMENTS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOCANCELLATIONS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOCANCELLATIONS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOITEMINFOS UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOITEMINFOS ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOPERIODPRICE UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOPERIODPRICE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOADDPERIODPRICE UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOADDPERIODPRICE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(50.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOTMPDAY UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOTMPDAY ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOMISC UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOMISC ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOMISCHOTEL UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOMISCHOTEL ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOMISCTEXT UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOMISCTEXT ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOARRANGEMENT UNSET PROFILE' )  @
CALL SYSPROC.ADMIN_CMD( 'RUNSTATS ON TABLE DB2ADMIN.TOOARRANGEMENT ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND SAMPLED DETAILED INDEXES ALL TABLESAMPLE SYSTEM(100.0) SET PROFILE' ); @

-- -----------------------------------------------------------------------------
-- EOF
-- -----------------------------------------------------------------------------
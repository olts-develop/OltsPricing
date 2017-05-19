set DELIM=--------------------------------------------------------------------------------
rem Set VERBOSE to "v" if verbose logging is required, e.g. "set VERBOSE=v".
set VERBOSE=
echo %1>>createfunctions.log
echo .>>createfunctions.log
db2 "CALL SET_ROUTINE_OPTS(GET_ROUTINE_OPTS() || ' ISOLATION UR')"
db2 -td@ -%VERBOSE%f %1>>createfunctions.log
echo %DELIM%>>createfunctions.log
echo %DELIM%>>createfunctions.log
set DELIM=--------------------------------------------------------------------------------
rem Set VERBOSE to "v" if verbose logging is required, e.g. "set VERBOSE=v".
set VERBOSE=
echo %1>>createfunctions.log
echo .>>createfunctions.log
db2 -td@ -%VERBOSE%f %1>>createfunctions.log
echo %DELIM%>>createfunctions.log
echo %DELIM%>>createfunctions.log
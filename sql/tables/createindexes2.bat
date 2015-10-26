echo  createindexes ...
echo off
rem ****************************************************************************
rem This batch file creates the TOO indexes
rem ****************************************************************************

c:
cd /d %~dp0

rem ----------------------------------------------------------------------------
rem Variables
rem ----------------------------------------------------------------------------

set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

set DELIM=--------------------------------------------------------------------------------

rem Set VERBOSE to "v" if verbose logging is required, e.g. "set VERBOSE=v".
set VERBOSE=

echo Start createtables.sql>createindexes.log
echo %DATE% %TIME%>>createindexes.log

   echo %DELIM%>>createindexes.log
   echo %DELIM%>>createindexes.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>createindexes.log
db2 set schema %DBUSERNAME%>>createindexes.log

   echo %DELIM%>>createindexes.log
   echo %DELIM%>>createindexes.log

rem createindexes
echo createindexes.sql>>createindexes.log
echo .>>createindexes.log
db2 -td@ -%VERBOSE%f createindexes.sql>>createindexes.log

echo %DELIM%>>createindexes.log
echo %DELIM%>>createindexes.log
echo %DATE% %TIME%>>createindexes.log
echo End createtables.sql>>createindexes.log


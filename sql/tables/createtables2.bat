echo  createtables ...
echo off
rem ****************************************************************************
rem This batch file creates the TOO tables
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

echo Start createtables.sql>createtables.log
echo %DATE% %TIME%>>createtables.log

   echo %DELIM%>>createtables.log
   echo %DELIM%>>createtables.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>createtables.log
db2 set schema %DBUSERNAME%>>createtables.log

   echo %DELIM%>>createtables.log
   echo %DELIM%>>createtables.log

rem createtables
echo createtables.sql>>createtables.log
echo .>>createtables.log
db2 -td@ -%VERBOSE%f createtables.sql>>createtables.log

echo %DELIM%>>createtables.log
echo %DELIM%>>createtables.log
echo %DATE% %TIME%>>createtables.log
echo End createtables.sql>>createtables.log

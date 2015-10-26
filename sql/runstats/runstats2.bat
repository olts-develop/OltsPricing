echo  runstats ...
echo off
rem ****************************************************************************
rem This batch file executes the RUNSTATS for all TOO tables
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
set VERBOSE=v

rem Start

echo Start runstats.sql>runstats.log
echo %DATE% %TIME%>>runstats.log

   echo %DELIM%>>runstats.log
   echo %DELIM%>>runstats.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>runstats.log
db2 set schema %DBUSERNAME%>>runstats.log

   echo %DELIM%>>runstats.log
   echo %DELIM%>>runstats.log

rem runstats
echo runstats.sql>>runstats.log
echo .>>runstats.log
db2 -td@ -%VERBOSE%f runstats.sql>>runstats.log

echo %DELIM%>>runstats.log
echo %DELIM%>>runstats.log
echo %DATE% %TIME%>>runstats.log
echo End runstats.sql>>runstats.log

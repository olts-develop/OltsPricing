echo  load-all ...
echo off
rem ****************************************************************************
rem This batch file deletes the data from all TOO tables and reimports from CSV
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



echo Start load-all.sql>load-all.log
echo %DATE% %TIME%>>load-all.log

   echo %DELIM%>>load-all.log
   echo %DELIM%>>load-all.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>load-all.log
db2 set schema %DBUSERNAME%>>load-all.log

   echo %DELIM%>>load-all.log
   echo %DELIM%>>load-all.log

rem load-all
echo load-all.sql>>load-all.log
echo .>>load-all.log
db2 -td@ -%VERBOSE%f load-all.sql>>load-all.log

echo %DELIM%>>load-all.log
echo %DELIM%>>load-all.log
echo %DATE% %TIME%>>load-all.log
echo End createfunctions>>load-all.log

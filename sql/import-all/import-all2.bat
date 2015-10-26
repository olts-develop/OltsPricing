echo  import-all ...
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

echo Start import-all.sql>import-all.log
echo %DATE% %TIME%>>import-all.log

   echo %DELIM%>>import-all.log
   echo %DELIM%>>import-all.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>import-all.log
db2 set schema %DBUSERNAME%>>import-all.log

   echo %DELIM%>>import-all.log
   echo %DELIM%>>import-all.log

rem import-all
echo import-all.sql>>import-all.log
echo .>>import-all.log
db2 -td@ -%VERBOSE%f import-all.sql>>import-all.log

echo %DELIM%>>import-all.log
echo %DELIM%>>import-all.log
echo %DATE% %TIME%>>import-all.log
echo End import-all.sql>>import-all.log

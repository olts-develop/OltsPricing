echo  import-diff ...
echo off
rem ****************************************************************************
rem This batch file updates the data in all TOO tables from CSV
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



echo Start import-diff.sql>import-diff.log
echo %DATE% %TIME%>>import-diff.log

   echo %DELIM%>>import-diff.log
   echo %DELIM%>>import-diff.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>import-diff.log
db2 set schema %DBUSERNAME%>>import-diff.log

   echo %DELIM%>>import-diff.log
   echo %DELIM%>>import-diff.log

rem import-diff
echo import-diff.sql>>import-diff.log
echo .>>import-diff.log
db2 -td@ -%VERBOSE%f import-diff.sql>>import-diff.log

echo %DELIM%>>import-diff.log
echo %DELIM%>>import-diff.log
echo %DATE% %TIME%>>import-diff.log
echo End import-diff.sql>>import-diff.log

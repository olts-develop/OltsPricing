echo on
rem ****************************************************************************
rem This batch file creates the TOO indexes
rem ****************************************************************************

set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

c:
cd /d %~dp0
db2cmd -c -w -i createindexes2.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
explorer createindexes.log
..\runstats\runstats.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

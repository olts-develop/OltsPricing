echo on
rem ****************************************************************************
rem This batch file deletes the data from all TOO tables and reimports from CSV
rem ****************************************************************************

set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

c:
cd /d %~dp0
db2cmd -c -w -i load-all2.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
..\runstats\runstats.bat

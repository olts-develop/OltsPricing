echo on
rem ****************************************************************************
rem This batch file updates the data in all TOO tables from CSV
rem ****************************************************************************

set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

c:
cd /d %~dp0
db2cmd -c -w -i import-diff2.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

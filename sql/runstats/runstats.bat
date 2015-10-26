echo off
rem ****************************************************************************
rem This batch file executes the RUNSTATS for all TOO tables
rem ****************************************************************************

set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

c:
cd /d %~dp0
db2cmd -c -w -i runstats2.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

explorer runstats.log

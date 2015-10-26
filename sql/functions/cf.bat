echo off
rem ****************************************************************************
rem This batch file creates all functions necessary for the pricing of products
rem ****************************************************************************

set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

c:
cd /d %~dp0
db2cmd -c -w -i cf2.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
db2cmd -c -w -i cf2.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

explorer createfunctions.log

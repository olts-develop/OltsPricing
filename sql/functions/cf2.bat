cd \
cls
echo  createfunctions ...
echo off
rem ****************************************************************************
rem This batch file creates all functions necessary for the pricing of hotels
rem ****************************************************************************

c:
cd /d %~dp0

rem ----------------------------------------------------------------------------
rem Variables
rem ----------------------------------------------------------------------------

set STARTDATETIME=%DATE% %TIME%
set DBNAME=%1
set DBUSERNAME=%2
set DBPASSWORD=%3

set DELIM=--------------------------------------------------------------------------------

echo Start: %STARTDATETIME%>createfunctions.log

echo %DELIM%>>createfunctions.log
echo %DELIM%>>createfunctions.log

db2 connect to %DBNAME% user %DBUSERNAME% using %DBPASSWORD%>>createfunctions.log
db2 set schema %DBUSERNAME%>>createfunctions.log

echo %DELIM%>>createfunctions.log
echo %DELIM%>>createfunctions.log

call cf3.bat elements2.sql
call cf3.bat func_getposdatedesc.sql
call cf3.bat func_roomvalid.sql
call cf3.bat func_miscvalid.sql
call cf3.bat func_all.sql
call cf3.bat func_spof3.sql
call cf3.bat func_pricing3.sql
call cf3.bat func_eb2.sql
call cf3.bat func_eb3.sql
call cf3.bat func_pricing2.sql
call cf3.bat func_test_price.sql
call cf3.bat func_pricing.sql
call cf3.bat func_miscpricing.sql
call cf3.bat func_roompricebydest.sql
call cf3.bat func_miscpricebydest.sql
call cf3.bat func_get_allotment2.sql

call cf3.bat func_test_price_flight.sql
call cf3.bat func_flightvalid.sql
call cf3.bat func_flightpricing.sql

call cf3.bat SP_PRICING_AV_HOTEL.sql
call cf3.bat SP_PRICING_AV_MISC.sql

db2 connect reset>>createfunctions.log

echo Start: %STARTDATETIME%>>createfunctions.log
echo End:   %DATE% %TIME%>>createfunctions.log

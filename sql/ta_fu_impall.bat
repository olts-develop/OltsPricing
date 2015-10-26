echo on
rem ****************************************************************************
rem This batch creates the tables, functions and imports all CSV files
rem ****************************************************************************

set DBNAME=XXXPROD
set DBUSERNAME=db2admin
set DBPASSWORD=xxxxxx

set DBNAME=STO
set DBUSERNAME=db2admin
set DBPASSWORD=SpaP7afEke

c:
cd /d %~dp0
set CURRDIR=%CD%

cd %CURRDIR%
cd tables
CALL createtables.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

set DBNAME=STO
set DBUSERNAME=db2admin
set DBPASSWORD=SpaP7afEke

cd %CURRDIR%
cd functions
CALL cf.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

set DBNAME=STO
set DBUSERNAME=db2admin
set DBPASSWORD=SpaP7afEke

cd %CURRDIR%
cd import-all
CALL import-all.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

set DBNAME=STO
set DBUSERNAME=db2admin
set DBPASSWORD=SpaP7afEke

cd %CURRDIR%
cd tables
CALL createindexes.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%

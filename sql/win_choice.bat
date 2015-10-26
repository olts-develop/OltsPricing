@echo off

cd /d %~dp0
set CURRDIR=%CD%

:init

set /p DBNAME= Please enter the DBNAME: 
set /p DBPASSWORD= Please enter the DBPASSWORD: 

set DBUSERNAME=db2admin

IF "%DBNAME%" == "" (
cls
echo Error: Please enter a DBNAME
goto init
)

IF "%DBPASSWORD%" == "" (
cls
echo Error: Please enter a DBPASSWORD
goto init
)

:start
@echo off
cls
cd %CURRDIR%
echo.
echo DBNAME     = %DBNAME%
echo DBUSERNAME = %DBUSERNAME%
echo DBPASSWORD = %DBPASSWORD%
echo.
echo          �������������������������ͻ
echo          �    Main Menu            �
echo          �������������������������͹
echo          �  1. create tables       �
echo          �  2. create indexes      �
echo          �  3. create functions    �
echo          �  4. import all          �
echo          �  5. import diff         �
echo          �  6. load all            �
echo          �  7. runstats            �
echo          �  8. EXIT                �
echo          �������������������������ͼ
echo.
choice /c 12345678 /m "Select an option: "

if errorlevel 8 goto exit
if errorlevel 7 goto 7
if errorlevel 6 goto 6
if errorlevel 5 goto 5
if errorlevel 4 goto 4
if errorlevel 3 goto 3
if errorlevel 2 goto 2
if errorlevel 1 goto 1

goto exit

:1
cd tables
CALL createtables.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:2
cd tables
CALL createindexes.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:3
cd functions
CALL cf.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:4
cd import-all
CALL import-all.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:5
cd import-diff
CALL import-diff.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:6
cd load-all
CALL load-all.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:7
cd runstats
CALL runstats.bat %DBNAME% %DBUSERNAME% %DBPASSWORD%
GOTO start

:exit
cls
cd\
cls

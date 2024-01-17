@echo off
set waste=
set str=
set /a index=0
REM Change storymode to ON for some spicy story telling.
set storymode=OFF
for /l %%i in (1,1,26) do CALL :numbers BALL

set chars=a b c d e f g h i j k l m n o p q r s t u v w x y z
for %%g in (%chars%) do set /a counter+=1 & CALL :constructor %%g
set ptr=%str%
set str=
set /a counter=1
for %%g in (%chars%) do CALL :CHECKER %%g
CALL :resetcounter
set ptr=%ptr:,,= %
set ptr=%ptr:,=%
set waste=%waste:,,= %
set waste=%waste:,=%
set final=%ptr% %waste%
set bookoflife= %chars%
set life=
if %storymode%==ON echo Final:%final%
if %storymode%==ON echo bookoflife:%bookoflife%
for %%g in (%final%) do CALL :CHECKBOOKOFLIFE %%g
if %storymode%==ON echo Lifeis:%life%
set ptr=%life:,,= %
set ptr=%ptr:,=%
set final=%ptr%
if %storymode%==ON echo %chars%
if %storymode%==ON echo %final%
if %storymode%==OFF echo Arrangement of Letters: %chars%
if %storymode%==OFF echo ^|_______^> Crypt Cipher: %final%
PAUSE
:numbers
set /a minimo=(%RANDOM%*26/32767)+1
if "%~1"=="BALL" CALL :construct %minimo% BALL
Exit /B
:construct
set str=%str%,%~1,
Exit /B
:constructor
CALL set str=%%str:,%counter%,=,%~1,%%
Exit /B
:setcounter
set /a counter+=1
exit /b
:resetcounter
set /a counter=1
exit /b
:CHECKER
set char=%~1
for %%g in (%ptr%) do  if %%g==%char% goto dontwastemytime
CALL :notfound %char%
:dontwastemytime
CALL :resetcounter
Exit /B
:notfound
set waste=%waste%,%~1,
Exit /b
:CLEAN
set char=%~1
if "%char%" NEQ "." set final=%final%,%char%,
if %char%==dup REM
Exit /b
:CHECKSETPINGER
CALL :increaseme
if %counter%==%pinger% set final=%final%,%~1,
set /a counter=pinger
CALL :resetme
Exit /b
:increaseme
set /a pinger+=1
exit /b
:resetme
set /a pinger=0
exit /b
:CHECKBOOKOFLIFE
if %storymode%==ON echo. Book of Life Opened: Character Attended %~1
for %%i in (%bookoflife%) do if "%%i"=="%~1" (if %storymode%==ON echo. Character Found^!)&set life=%life%,%%i,
CALL set bookoflife=%%bookoflife: %~1=%%
if %storymode%==ON echo bookoflifenow:(%bookoflife%)
Exit /b

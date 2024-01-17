:talker
setlocal enabledelayedexpansion
@echo off
if exist key.bat call key.bat
if defined key__ for %%a in (%key__%) DO set /a counteng+=1
if not defined KEY__ goto check_key
set /a countering=0
echo.@echo off >decode.bat
echo.set stringtodecode=%%1 >>decode.bat
for %%a in (%key__%) do call :print_decode %%a&set /a countering+=1
echo.echo %%stringtodecode%% >>decode.bat
goto check_key
:print_decode
echo set stringtodecode=%%stringtodecode:,%countering%,=%1%% >>decode.bat
exit /b
:check_key


mode 60,20
Set _fDGray=[90m
Set _RESET=[0m
Set _fGreen=[32m
SET LF=^


REM TWO empty lines are required

echo. ******************************************
echo.             Be Safe
echo.                   Save your Soul
echo. Use the right keys and avoid the following
echo.                ^>  ^<  ^&  ^|  " ^ ^!
echo.     Allowed symbols , : / \ * $ @ #                    
echo.

if defined counteng if "%counteng%" GEQ "25" echo.      Encryption Key "seems" OK[%counteng%]
if not defined counteng ( echo.          Key seems missing ^[No encryption^] )
PAUSE 
timeout 3 >NUL
set server=.\
set /p nickname=Enter your nickname (no duplicates allowed.):
set /p chatroom=Enter chatroom ID or name:
set nickname=%nickname: =%
set chatroom=%chatroom: =%
title You:%nickname%,Room:%chatroom% Press T to talk
cls
for /f  "tokens=2 delims=," %%i in ('wmic os get localdatetime /format:csv') do set timer=%%i
set timer=%timer:~0,8%
if NOT EXIST %server%%chatroom%%timer%.txt echo.  >%server%%chatroom%%timer%.txt
call :CHECKSIZE
echo.somebodyentered: %nickname% >>%server%%chatroom%%timer%.txt
:keeprepeat
call :CHECKSIZE

choice /t 1 /c TX /d X >NUL
if %errorlevel%==1 ( CALL :TALK)

goto keeprepeat
:TALK
echo.somebodyistyping: %nickname% >>%server%%chatroom%%timer%.txt
REM echo %_fDGray% 2>NUL&
echo | set /p=%_fDGray%%nickname%: :&echo | set /p=%_RESET%
REM echo | set /p=%nickname%: :
set /p talker=
set talkischeap=
set /a skip_talk=0
if defined key__ for /l %%g in (0,1,200) do CALL :getchar_ %%g
if defined key__ ECHO %nickname%: :%talkischeap%  >>%server%%chatroom%%timer%.txt
if not defined key__ ECHO %nickname%: :%talker%  >>%server%%chatroom%%timer%.txt
CALL :CHECKSIZE
exit /b
:getchar_
if %skip_talk%==1 Exit /B
CALL set char_single=%%talker:~%1,1%%
if "%char_single%"=="" set /a skip_talk=1&Exit /B
if "%char_single%" NEQ " " CALL :Constructor %char_single%
if "%char_single%"==" " set talkischeap=%TalkisCheap% &set /a constructor_next=0
if %constructor_next%==1 set talkischeap=%TalkisCheap%,%incrementalcounter%,
Exit /B
:constructor
set /a constructor_next=0
set /a incrementalcounter=0
for %%g in (%key__%) do (if /I "%%g"=="%1" set /a constructor_next=1&Exit /B)&set /a incrementalcounter+=1
:constructor_next
Exit /B
:check_char

Exit /B
:READ
set contents=
set lastline=
REM debug mode: echo.here!diff!
SET /A TOTAL=LINE-DIFF
SET /A COUNTER=0
if %total%==0 set /a total=1
 for /f "skip=%total% delims=" %%i in ('TYPE %server%%chatroom%%timer%.txt ' ) do SET "contents=!contents!%%i!LF!"
REM for /f "delims=" %%i in ('powershell -c "get-content %server%%chatroom%%timer%.txt -tail !diff!"' ) do SET "contents=!contents!%%i!LF!"
REM debug mode: echo. attention
REM debug mode: echo !contents!
REM debug mode: echo. i said attention 
REM debug mode: echo. test 2
call :decode_it
for /f "delims=" %%i in ("!contents!") do echo %%i | findstr /v /r "^somebodyistyping:" |  findstr /v /r "^somebodyentered:" | findstr /v /r "^%nickname%:"
for /f "delims=" %%i in ('echo !contents!') do set lastline=%%i
set str=
for /f "tokens=2" %%i in ('echo !lastline! ^|  findstr /r "^somebodyistyping:"') do set str=%%i
if "!str!" NEQ "" (IF "!STR!" neq "%NICKNAME%" Title !str! is typing..) else (title  You:%nickname%,Room:%chatroom% Press T to talk)
set str=
for /f "tokens=2" %%i in ('echo !lastline!  ^|  findstr /r "^somebodyentered:"') do set str=%%i
if "!str!" NEQ ""  echo | set /p= %_fGREEN%!str!%_RESET% entered the chat&echo.
exit /b
:decode_it
if exist decode.bat for /f "tokens=*" %%i in ('decode.bat "!contents!"') do set contents=%%~i
Exit /b
:CHECKLINE
set /a counter=0
for /f "delims=" %%i in ('type %server%%chatroom%%timer%.txt') do set /a counter+=1
set /a line=!counter!
REM debug mode: echo oldline!oldline! ^& line!line!
REM debug mode: echo.!diff!diff&
if !oldline! NEQ !line! set /a diff=line-oldline & set /a oldline=line & CALL :READ
set /a oldline=line 
exit /b
:CHECKSIZE
for /f "tokens=3" %%i in ('dir %server%%chatroom%%timer%.txt ^| find "1 File(s)"') do set Size=%%i
if "!size!" NEQ "!oldsize!" set oldsize=%size%& CALL :CHECKLINE
set oldsize=%size%
exit /b

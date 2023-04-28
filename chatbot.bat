:talker
setlocal enabledelayedexpansion
@echo off
mode 60,20
Set _fDGray=[90m
Set _RESET=[0m
Set _fGreen=[32m
SET LF=^


REM TWO empty lines are required
POWERSHELL -FILE powershell-copy-art-title.PS1
pause >nul
echo. ******************************************
echo.                       Please Do not Use the 
echo.                    Following Symbols As 
echo.                      it may break Chat
echo.                ^>  ^<  ^&  ^|  
echo.                     " ^
echo.
PAUSE
set server=.\
set /p nickname=Enter your nickname (no duplicates allowed.):
set /p chatroom=Enter chatroom ID or name:
set nickname=%nickname: =%
set chatroom=%chatroom: =%
title Room:%chatroom% Press T to talk
cls
for /f  "tokens=2 delims=," %%i in ('wmic os get localdatetime /format:csv') do set timer=%%i
set timer=%timer:~0,8%
if NOT EXIST %server%%chatroom%%timer%.txt echo.  >%server%%chatroom%%timer%.txt
for /f "tokens=3" %%i in ('dir %server%%chatroom%%timer%.txt ^| find "1 File(s)"') do set Size=%%i
set oldsize=%size%
call :CHECKLINE
echo.somebodyentered: %nickname% >>%server%%chatroom%%timer%.txt
:keeprepeat
for /f "tokens=3" %%i in ('dir %server%%chatroom%%timer%.txt ^| find "1 File(s)"') do set Size=%%i
if "!size!" NEQ "!oldsize!" set oldsize=%size%& CALL :CHECKLINE & CALL :READ

choice /t 1 /c TX /d X >NUL
if %errorlevel%==1 ( CALL :TALK)

goto keeprepeat
:TALK
echo.somebodyistyping: %nickname% >>%server%%chatroom%%timer%.txt
echo %_fDGray%&echo | set /p=%nickname%: :&echo | set /p=%_RESET%
REM echo | set /p=%nickname%: :
set /p talker=
ECHO %nickname%: :%talker%  >>%server%%chatroom%%timer%.txt
exit /b
:READ
set /a counter=0
for /f "delims=" %%i in ('type %server%%chatroom%%timer%.txt') do set lastline=%%i
echo !lastline! | findstr /r "^somebodyistyping:" >NUL&&goto ignore
echo !lastline! | findstr /r "^somebodyentered:" >NUL&&goto ignore
CALL :CHECKLINE
set contents=
for /f "delims=" %%i in ('powershell -c "get-content %server%%chatroom%%timer%.txt -tail !diff!"' ) do SET "contents=!contents!%%i!LF!"
echo !contents! |  findstr /v /r "^%nickname%:" | findstr /v /r "^somebodyistyping:" |  findstr /v /r "^somebodyentered:"
goto ignored
:ignore
set contents=!lastline!
:ignored
for /f "tokens=*" %%i in ('echo !contents!') do set expr=%%i
set str=
for /f "tokens=2" %%i in ('echo !expr! ^|  findstr /r "^somebodyistyping:"') do set str=%%i
if "!str!" NEQ "" (Title !str! is typing..) else (title Room:%chatroom% Press T to talk)
set str=
for /f "tokens=2" %%i in ('echo !expr!  ^|  findstr /r "^somebodyentered:"') do set str=%%i
if "!str!" NEQ "" echo.&echo %_fGREEN%&echo | set /p=!str!%_RESET% entered the chat&echo.
exit /b
:CHECKLINE
set /a counter=0
for /f "delims=" %%i in ('type %server%%chatroom%%timer%.txt') do set /a counter+=1
set /a line=counter
if !oldline! NEQ !line! set /a diff=line-oldline
set /a oldline=line
exit /b

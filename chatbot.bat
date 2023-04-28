:talker
setlocal enabledelayedexpansion
@echo off
mode 45,20
echo. ******************************************
echo.                       Please Do not Use the 
echo.                    Following Symbols As 
echo.                      it may break Chat
echo.                ^>  ^<  ^&  ^|  
echo.                     " ^
echo.
PAUSE
set server=.\
set /p nickname=Enter your nickname (no duplicates allowed.)
set /p chatroom=Enter chatroom ID or name
set nickname=%nickname: =%
set chatroom=%chatroom: =%
title Room:%chatroom% Press T to talk
cls
for /f  "tokens=2 delims=," %%i in ('wmic os get localdatetime /format:csv') do set timer=%%i
set timer=%timer:~0,8%
if NOT EXIST %server%%chatroom%%timer%.txt echo.  >%server%%chatroom%%timer%.txt
for /f "tokens=3" %%i in ('dir %server%%chatroom%%timer%.txt ^| find "1 File(s)"') do set Size=%%i
set oldsize=%size%
for /f %%i in ('powershell -c "( Get-Content %server%%chatroom%%timer%.txt | Measure-Object -line ).lines"') do set oldline=%%i
echo.somebodyentered: %nickname% >>%server%%chatroom%%timer%.txt
:keeprepeat
for /f "tokens=3" %%i in ('dir %server%%chatroom%%timer%.txt ^| find "1 File(s)"') do set Size=%%i
if "!size!" NEQ "!oldsize!" set oldsize=%size%& CALL :CHECKLINE & CALL :READ

choice /t 1 /c TX /d X >NUL
if %errorlevel%==1 ( CALL :TALK)

goto keeprepeat
:TALK
echo.somebodyistyping: %nickname% >>%server%%chatroom%%timer%.txt
powershell -c "write-host -nonewline -fore darkgray %nickname%: :"
REM echo | set /p=%nickname%: :
set /p talker=
ECHO %nickname%: :%talker%  >>%server%%chatroom%%timer%.txt
exit /b
:READ
for /f %%i in ('powershell -c "( Get-Content %server%%chatroom%%timer%.txt | Measure-Object -line ).lines"') do set oldline=%%i
powershell -c "get-content %server%%chatroom%%timer%.txt -tail !diff!" |  findstr /v /r "^%nickname%:" | findstr /v /r "^somebodyistyping:" |  findstr /v /r "^somebodyentered:"
set str=
for /f "tokens=2" %%i in ('powershell -c "get-content %server%%chatroom%%timer%.txt -tail 1"  ^|  findstr /r "^somebodyistyping:"') do set str=%%i
if "!str!" NEQ "" (Title !str! is typing..) else (title Room:%chatroom% Press T to talk)
set str=
for /f "tokens=2" %%i in ('powershell -c "get-content %server%%chatroom%%timer%.txt -tail 1"  ^|  findstr /r "^somebodyentered:"') do set str=%%i
if "!str!" NEQ "" echo.&powershell -c "write-host -nonewline -fore green \"!str! \";write-host -nonewline entered the chat."&echo.
exit /b
:CHECKLINE
for /f %%i in ('powershell -c "( Get-Content %server%%chatroom%%timer%.txt | Measure-Object -line ).lines"') do set line=%%i
if !oldline! NEQ !line! set /a diff=line-oldline

@echo off

rem -------------------------------------------------------------------------------
rem Swaps the order of targets and instructions on the command line.
rem -------------------------------------------------------------------------------
rem main uses:
rem     Used when repeating several instructions to one target.
rem     (concept: like a object oriented.)
rem usage:
rem     a[.cmd] target [instruction]
rem target:
rem     file path.
rem instruction:
rem     command line. (default: show digest information of target)
rem     target relace holder:
rem         `???` or ` to `
rem example:
rem     a foo.txt
rem         --> show digest information (target attributes, etc...)
rem     a foo.txt type
rem     a foo.txt type ???
rem         --> type foo.txt
rem     a foo.txt copy ??? bar.txt
rem     a foo.txt copy to bar.txt
rem         --> copy foo.txt bar.txt

setlocal EnableDelayedExpansion

set TARGET=%1
if not defined TARGET (
    call bshelp.cmd "%~f0"
    exit /b 1
)
set TARGET=%TARGET:/=\%
set INSTRUCTION=

:JOIN_INSTRUCTION_PART

shift /1
set ARG_RAW=%1
if not defined ARG_RAW goto DETERMINE_INSTRUCTION

set INSTRUCTION=%INSTRUCTION% %~1
goto JOIN_INSTRUCTION_PART

:DETERMINE_INSTRUCTION

if defined INSTRUCTION goto GENERATE_COMMAND_LINE

:DEFAULT_INSTRUCTION

dir /a- %TARGET% >nul
if ERRORLEVEL 1 exit /b 1

call ps.cmd -Command "Get-Item %TARGET% -Force | Select-Object Name, @{n='LastWriteTime';e={$_.LastWriteTime.ToISOLike()}}, Length, Mode | Format-Table -Wrap"
call ps.cmd -Command "(Get-Item -LiteralPath %TARGET% -Force).GetFileHash().GetCaptionWithBase64()" 2>nul
git status --short --branch -- %TARGET% 2>nul
git log --follow -3 --pretty=format:"%%C(yellow)%%h %%C(reset)%%s %%C(yellow)%%cr %%C(cyan)%%ar %%C(auto)%%d%%C(reset)" -- %TARGET% 2>nul
exit /b 0

:GENERATE_COMMAND_LINE

set INSTRUCTION=%INSTRUCTION:~1%

:: try: replace `???` to target.
set COMMAND_LINE=!INSTRUCTION:???=%TARGET%!
if "%COMMAND_LINE%" neq "%INSTRUCTION%" goto EXECUTION_CONFIRMATION

:: try: replace `to` to target.
set COMMAND_LINE=!INSTRUCTION: to = %TARGET% !
if "%COMMAND_LINE%" neq "%INSTRUCTION%" goto EXECUTION_CONFIRMATION

:: target append to tail.
set COMMAND_LINE=%INSTRUCTION% %TARGET%

:EXECUTION_CONFIRMATION

echo.^>^>^> %COMMAND_LINE%

:ASK_YN

set ANS_YN=y
set /p ANS_YN="[Y]/n ? > "

if /i "%ANS_YN%" equ "n" exit /b 0
if /i "%ANS_YN%" neq "y" goto ASK_YN

:EXECUTE

echo.
%COMMAND_LINE%

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
rem     command line. (default: `dir`)
rem     target relace holder:
rem         `???` or ` to `
rem example:
rem     a foo.txt
rem         --> dir foo.txt
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
set INSTRUCTION=

:JOIN_INSTRUCTION_PART

shift /1
set ARG_RAW=%1
if not defined ARG_RAW goto DETERMINE_INSTRUCTION

set INSTRUCTION=%INSTRUCTION% %~1
goto JOIN_INSTRUCTION_PART

:DETERMINE_INSTRUCTION

if not defined INSTRUCTION set INSTRUCTION= dir ???
set INSTRUCTION=%INSTRUCTION:~1%

:GENERATE_COMMAND_LINE

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

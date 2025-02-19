@echo off

rem -------------------------------------------------------------------------------
rem Common Operation Helper for Multiple Files
rem -------------------------------------------------------------------------------
rem usage:
rem     foreach[.cmd] target [instruction]
rem arguments:
rem     target:
rem         e.g. `*.txt`
rem     instruction:
rem         command. (default: `echo`)
rem example:
rem     foreach *.txt tw.cmd
rem         -> for %a in (*.txt) do call tw.cmd %a

setlocal

set TARGETS=%1
if not defined TARGETS (
    call bshelp.cmd "%~f0"
    exit /b 1
)

set INSTRUCTION=%~2
if not defined INSTRUCTION set INSTRUCTION=echo

for %%f in ( %TARGETS% ) do call :EXECUTE "%%~f"

echo.
echo completed.
exit /b 0

:EXECUTE

set TARGET=%1
set COMMAND_LINE=%INSTRUCTION% %TARGET%

echo.%COMMAND_LINE%
call %COMMAND_LINE%
goto :EOF

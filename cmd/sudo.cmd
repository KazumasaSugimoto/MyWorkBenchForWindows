@echo off

rem Start with administrator privileges
rem
rem usage:
rem     sudo[.cmd] <sub-command>
rem
rem sub-commands:
rem     cmd
rem         Start Command Prompt `cmd.exe`
rem     ps5 | wps
rem         Start Windows PowerShell `powershell.exe`
rem     ps7 | ps
rem         Start PowerShell `pwsh.exe`
rem     --help | /help | -? | /?
rem         Show Help
rem     --edit-self | -es | /es | :es
rem         Edit this source code.

setlocal

set HELP_OPTION=--help /help -? /?
set EDIT_OPTION=--edit-self -es /es :es

for /f "usebackq tokens=1" %%a in (`echor.cmd %HELP_OPTION%`) do if /i "%%a" equ "%~1" goto :SHOW_HELP
for /f "usebackq tokens=1" %%a in (`echor.cmd %EDIT_OPTION%`) do if /i "%%a" equ "%~1" goto :EDIT_SELF

set TARGET_PROCESS=
for /f "usebackq tokens=1" %%a in (`echor.cmd cmd`)     do if /i "%%a" equ "%~1" set TARGET_PROCESS=cmd.exe -ArgumentList '/t:5F /k """cd /d %CD%"""'
for /f "usebackq tokens=1" %%a in (`echor.cmd ps5 wps`) do if /i "%%a" equ "%~1" set TARGET_PROCESS=powershell.exe -ArgumentList '-NoExit -Command cd """%CD%"""'
for /f "usebackq tokens=1" %%a in (`echor.cmd ps7 ps`)  do if /i "%%a" equ "%~1" set TARGET_PROCESS=pwsh.exe -ArgumentList '-NoExit -Command cd """%CD%"""'

if defined TARGET_PROCESS goto LAUNCH_TARGET_PROCESS

call :SET_2TO1 TARGET_PROCESS %~1 wt.exe

:LAUNCH_TARGET_PROCESS

powershell -command start-process %TARGET_PROCESS% -verb runas
exit /b 0

:SET_2TO1

set %~1=%~2
goto :EOF

:SHOW_HELP

call bshelp.cmd "%~f0"
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

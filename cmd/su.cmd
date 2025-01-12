@echo off

setlocal

set HELP_OPTION=--help /help -? /?
set EDIT_OPTION=--edit /edit --code /code --source /source

for /f "usebackq tokens=1" %%a in (`echov %HELP_OPTION%`) do if /i "%%a" equ "%~1" goto :SHOW_HELP
for /f "usebackq tokens=1" %%a in (`echov %EDIT_OPTION%`) do if /i "%%a" equ "%~1" goto :EDIT_SELF

set TARGET_PROCESS=
for /f "usebackq tokens=1" %%a in (`echov cmd`)     do if /i "%%a" equ "%~1" set TARGET_PROCESS=cmd.exe
for /f "usebackq tokens=1" %%a in (`echov ps5 wps`) do if /i "%%a" equ "%~1" set TARGET_PROCESS=powershell.exe
for /f "usebackq tokens=1" %%a in (`echov ps7 ps`)  do if /i "%%a" equ "%~1" set TARGET_PROCESS=pwsh.exe

if defined TARGET_PROCESS goto LAUNCH_TARGET_PROCESS

call :SET_2TO1 TARGET_PROCESS %~1 wt.exe

:LAUNCH_TARGET_PROCESS

powershell -command start-process %TARGET_PROCESS% -verb runas
exit /b 0

:SET_2TO1

set %~1=%~2
goto :EOF

:SHOW_HELP

echo Start with administrator privileges
echo.
echo USAGE:
echo     %~n0[%~x0] ^<sub-command^>
echo.
echo SUB-COMMANDS:
echo     cmd
echo         Launch Command Prompt `cmd.exe`
echo     ps5 ^| wps
echo         Launch Windows PowerShell `powershell.exe`
echo     ps7 ^| ps
echo         PowerShell `pwsh.exe`
echo     %HELP_OPTION: = ^| %
echo         Show Help
echo     %EDIT_OPTION: = ^| %
echo         Edit this source code.

exit /b 0

:EDIT_SELF

code "%~f0"

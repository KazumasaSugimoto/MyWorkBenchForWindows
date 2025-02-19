@echo off

rem -------------------------------------------------------------------------------
rem `shutdown` command helper
rem -------------------------------------------------------------------------------
rem
rem usage:
rem
rem     pc[.cmd] sub-command
rem
rem sub-command:
rem
rem     poweroff | off | shutdown | down
rem     suspend | sleep | zzz
rem     reboot
rem     logout | signout | out | logoff

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal

set SUBCMDS_POWEROFF=poweroff off shutdown down
set SUBCMDS_SUSPEND=suspend sleep zzz
set SUBCMDS_REBOOT=reboot
set SUBCMDS_LOGOUT=logout signout out logoff

set SHUTDOWN_OPTIONS=

for /f "usebackq tokens=*" %%a in (`echor.cmd %SUBCMDS_POWEROFF%`) do if /i "%~1" equ "%%a" set SHUTDOWN_OPTIONS=-s -hybrid -t 0
for /f "usebackq tokens=*" %%a in (`echor.cmd %SUBCMDS_SUSPEND%` ) do if /i "%~1" equ "%%a" set SHUTDOWN_OPTIONS=-h
for /f "usebackq tokens=*" %%a in (`echor.cmd %SUBCMDS_REBOOT%`  ) do if /i "%~1" equ "%%a" set SHUTDOWN_OPTIONS=-r -t 0
for /f "usebackq tokens=*" %%a in (`echor.cmd %SUBCMDS_LOGOUT%`  ) do if /i "%~1" equ "%%a" set SHUTDOWN_OPTIONS=-l

if defined SHUTDOWN_OPTIONS (
    shutdown %SHUTDOWN_OPTIONS%
    exit /b 0
)

call bshelp.cmd "%~f0"
echo.

:SELECT_SUBCMD

set ANS_SUBCMD=
set /p ANS_SUBCMD="? > "
if defined ANS_SUBCMD call %~nx0 %ANS_SUBCMD%
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

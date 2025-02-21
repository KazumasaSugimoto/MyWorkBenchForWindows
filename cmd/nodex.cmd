@echo off

rem -------------------------------------------------------------------------------
rem Outputs all sort orders of nodes.
rem -------------------------------------------------------------------------------
rem usage:
rem     nodex[.cmd] literal [separator]
rem literal:
rem     e.g. "a.b.c"
rem separator:
rem     e.g. "." ( default: "." )
rem example:
rem     nodex 1.2.3
rem         result:
rem             1.2.3
rem             1.3.2
rem             2.1.3
rem             2.3.1
rem             3.1.2
rem             3.2.1

if "%~1" equ "" goto SHOW_HELP
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set NODES=%~1
set SEPARATOR=%~2
if not defined SEPARATOR set SEPARATOR=.

:SPLIT_NODES

set NODES="!NODES:%SEPARATOR%=" "!"
set NODES.COUNT=0

for /f "usebackq tokens=*" %%n in (`echor.cmd %NODES%`) do (
    set /a NODES.COUNT+=1
    set NODES[!NODES.COUNT!]=%%n
)

if %NODES.COUNT% equ 0 goto SHOW_HELP

:DO_MAIN

for /f "usebackq tokens=*" %%a in (`gaso.cmd %NODES.COUNT%`) do call :SUB_MAIN "%%a"
exit /b 0

:SUB_MAIN

set RESULT=
for /f "usebackq tokens=*" %%i in (`echor.cmd %~1`) do (
    set RESULT=!RESULT!%SEPARATOR%!NODES[%%i]!
)
echo %RESULT:~1%
goto :EOF

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:SHOW_HELP

call bshelp.cmd "%~f0"
exit /b 1

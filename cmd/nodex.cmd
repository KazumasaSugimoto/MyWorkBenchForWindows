@echo off

rem Outputs all sort orders of nodes.

if "%~1" equ "" goto SHOW_HELP
for /f "usebackq tokens=*" %%a in (`echov.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set NODES=%~1
set SEPARATOR=%~2
if not defined SEPARATOR set SEPARATOR=.

:SPLIT_NODES

set NODES="!NODES:%SEPARATOR%=" "!"
set NODES.COUNT=0

for /f "usebackq tokens=*" %%n in (`echov.cmd %NODES%`) do (
    set /a NODES.COUNT+=1
    set NODES[!NODES.COUNT!]=%%n
)

if %NODES.COUNT% equ 0 goto SHOW_HELP

:DO_MAIN

for /f "usebackq tokens=*" %%a in (`gaso.cmd %NODES.COUNT%`) do call :SUB_MAIN "%%a"
exit /b 0

:SUB_MAIN

set RESULT=
for /f "usebackq tokens=*" %%i in (`echov.cmd %~1`) do (
    set RESULT=!RESULT!%SEPARATOR%!NODES[%%i]!
)
echo %RESULT:~1%
goto :EOF

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:SHOW_HELP

echo -------------------------------------------------------------------------------
echo Outputs all sort orders of nodes.
echo -------------------------------------------------------------------------------
echo.
echo usage:
echo.
echo     %~n0[%~x0] literal [separator]
echo.
echo literal:
echo.
echo     e.g. "a.b.c"
echo.
echo separator:
echo.
echo     e.g. "." ( default: "." )
echo.
echo example:
echo.
echo     %~n0 1.2.3
echo.
echo         1.2.3
echo         1.3.2
echo         2.1.3
echo         2.3.1
echo         3.1.2
echo         3.2.1

exit /b 1

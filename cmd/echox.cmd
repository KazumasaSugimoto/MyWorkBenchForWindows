@echo off

rem Outputs all sort orders of arguments.

if "%~1" equ "" goto SHOW_HELP
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set ARGS.COUNT=0

:SET_ARGS

set /a ARGS.COUNT+=1
set ARGS[%ARGS.COUNT%]=%~1

shift /1
if "%~1" neq "" goto SET_ARGS

:DO_MAIN

for /f "usebackq tokens=*" %%a in (`gaso.cmd %ARGS.COUNT%`) do call :SUB_MAIN "%%a"
exit /b 0

:SUB_MAIN

set RESULT=
for /f "usebackq tokens=*" %%i in (`echor.cmd %~1`) do (
    set RESULT=!RESULT! !ARGS[%%i]!
)
echo.%RESULT:~1%
goto :EOF

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:SHOW_HELP

echo -------------------------------------------------------------------------------
echo Outputs all sort orders of arguments.
echo -------------------------------------------------------------------------------
echo.
echo usage:
echo.
echo     %~n0[%~x0] arguments...
echo.
echo example:
echo.
echo     %~n0 a b
echo.
echo         a b
echo         b a
echo.
echo     %~n0 a b c
echo.
echo         a b c
echo         a c b
echo         b a c
echo         b c a
echo         c a b
echo         c b a

exit /b 1

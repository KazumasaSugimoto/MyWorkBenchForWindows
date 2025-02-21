@echo off

rem -------------------------------------------------------------------------------
rem Outputs all sort orders of arguments.
rem -------------------------------------------------------------------------------
rem usage:
rem     echox[.cmd] arguments...
rem example:
rem     case1:
rem         echox a b
rem             result:
rem                 a b
rem                 b a
rem     case2:
rem         echox a b c
rem             result:
rem                 a b c
rem                 a c b
rem                 b a c
rem                 b c a
rem                 c a b
rem                 c b a

if "%~1" equ "" (
    call bshelp.cmd "%~f0"
    exit /b 1
)

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

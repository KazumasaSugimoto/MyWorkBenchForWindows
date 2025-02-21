@echo off

rem -------------------------------------------------------------------------------
rem Generate All Sort Orders
rem -------------------------------------------------------------------------------
rem usage:
rem     gaso[.cmd] number-of-elements
rem example:
rem     case1:
rem         gaso 2
rem             result:
rem                 1 2
rem                 2 1
rem     case2:
rem         gaso 3
rem             result:
rem                 1 2 3
rem                 1 3 2
rem                 2 1 3
rem                 2 3 1
rem                 3 1 2
rem                 3 2 1

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set COUNT=%~1
set /a COUNT+=0

if %COUNT% lss 1 (
    call bshelp.cmd "%~f0"
    exit /b 1
)

set RESULT=
set DEPTH=0

:LOOP

setlocal

set /a DEPTH+=1

for /l %%i in ( 1, 1, %COUNT% ) do (
    if not defined USED_FLG_%%i (
        set RESULT=%RESULT% %%i
        set USED_FLG_%%i=defined - this value can be anything.
        if %COUNT% equ %DEPTH% (
            echo.!RESULT:~1!
        ) else (
            call :LOOP
        )
        set USED_FLG_%%i=
    )
)

exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

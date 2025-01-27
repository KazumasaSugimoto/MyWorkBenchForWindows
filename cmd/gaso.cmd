@echo off

rem Generate All Sort Orders

for /f "usebackq tokens=*" %%a in (`echov.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set COUNT=%~1
set /a COUNT+=0

if %COUNT% lss 1 goto SHOW_HELP

set RESULT=
set DEPTH=0

:LOOP

setlocal

set /a DEPTH+=1

for /l %%i in ( 1, 1, %COUNT% ) do (
    if not defined USED_FLG_%%i (
        set RESULT=%RESULT% %%i
        set USED_FLG_%%i=True
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

:SHOW_HELP

echo -------------------------------------------------------------------------------
echo Generate All Sort Orders
echo -------------------------------------------------------------------------------
echo.
echo usage:
echo.
echo     %~n0[%~x0] number-of-elements
echo.
echo example:
echo.
echo     %~n0 2
echo.
echo         1 2
echo         2 1
echo.
echo     %~n0 3
echo.
echo         1 2 3
echo         1 3 2
echo         2 1 3
echo         2 3 1
echo         3 1 2
echo         3 2 1

exit /b 1

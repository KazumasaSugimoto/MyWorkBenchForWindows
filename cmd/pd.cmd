@echo off

rem -------------------------------------------------------------------------------
rem pushd / popd operation helper
rem -------------------------------------------------------------------------------
rem 
rem usage:
rem 
rem     --- pushd mode ---
rem 
rem     pd[.cmd] destination
rem         destination: folder path -> tag name -> environment variable name
rem 
rem     --- popd mode ---
rem 
rem     pd[.cmd]
rem 
rem     --- current directory tagging mode ---
rem 
rem     pd[.cmd] . tag-name
rem 
rem     --- tag remove mode ---
rem 
rem     pd[.cmd] / tag-name
rem 
rem     --- help mode ---
rem 
rem     pd[.cmd] ?

if "%~1" equ ""  goto POPD_MODE
if "%~1" equ "." goto TAGGING_MODE
if "%~1" equ "/" goto TAG_REMOVE_MODE
if "%~1" equ ":" goto SUB_COMMAND_MODE
if "%~1" equ "?" goto HELP_MODE

:PUSHD_MODE

setlocal EnableDelayedExpansion

set DESTINATION=%~1

if exist "%DESTINATION%" goto DO_PUSHD

if defined PD_TAGs[%DESTINATION%] (
    set DESTINATION=!PD_TAGs[%DESTINATION%]!
) else if defined %DESTINATION% (
    set DESTINATION=!%DESTINATION%!
)

:DO_PUSHD

endlocal & pushd "%DESTINATION%"
exit /b %ERRORLEVEL%

:POPD_MODE

popd
exit /b 0

:TAGGING_MODE

echo --- current directory tagging mode ---

if "%~2" equ "" (
    echo.
    echo usage:
    echo     %~n0[%~x0] . tag-name
    echo.
    set PD_TAGs[ 2>nul
    exit /b 1
)

set PD_TAGs[%~2]=%CD%
set PD_TAGs[%~2] | findstr /b /i /l "PD_TAGs[%~2]="

exit /b 0

:TAG_REMOVE_MODE

echo --- tag remove mode ---

if "%~2" equ "" (
    echo.
    echo usage:
    echo     %~n0[%~x0] / tag-name
    echo.
    set PD_TAGs[ 2>nul
    exit /b 1
)

set PD_TAGs[%~2] | findstr /b /i /l "PD_TAGs[%~2]="
if ERRORLEVEL 1 (
    echo "%~2" was not found.
    exit /b 1
)

set PD_TAGs[%~2]=
echo "%~2" was removed.

exit /b 0

:SUB_COMMAND_MODE

echo --- sub-command mode ---

if /i "%~2"     equ "today"     goto MOVE_TO_TODAY'S_TEMP_FOLDER
if /i "%~2 %~3" equ "edit self" goto EDIT_SELF

echo.
echo usage:
echo     %~n0[%~x0] : sub-command
echo sub-command:
echo     today
echo     edit self
exit /b 1

:MOVE_TO_TODAY'S_TEMP_FOLDER

setlocal

set YMD=%DATE:/=%
set YMD=%YMD:-=%
set DESTINATION=%TEMP%\%YMD:~0,4%\%YMD:~0,6%\%YMD%

mkdir "%DESTINATION%" 2>nul

endlocal & pushd "%DESTINATION%"
exit /b %ERRORLEVEL%

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:HELP_MODE

call bshelp.cmd "%~f0"
exit /b 0

@echo off

rem pushd/popd helper

if "%~1" equ ""  goto POPD_MODE
if "%~1" equ "." goto TAGGING_MODE
if "%~1" equ "/" goto TAG_REMOVE_MODE

:PUSHD_MODE

setlocal EnableDelayedExpansion

set DESTINATION=%~1

if not exist "%DESTINATION%" (
    if defined PD_TAGs[%DESTINATION%] (
        set DESTINATION=!PD_TAGs[%DESTINATION%]!
    )
    if defined %DESTINATION% (
        set DESTINATION=!%DESTINATION%!
    )
)

endlocal & pushd "%DESTINATION%"
exit /b %ERRORLEVEL%

:POPD_MODE

popd
exit /b 0

:TAGGING_MODE

echo --- current directory tagging mode ---

if "%~2" equ "" (
    echo usage:
    echo     %~n0[%~x0] . tag-name
    exit /b 1
)

set PD_TAGs[%~2]=%CD%
set PD_TAGs[%~2] | findstr /b /i /l "PD_TAGs[%~2]="

exit /b 0

:TAG_REMOVE_MODE

echo --- tag remove mode ---

if "%~2" equ "" (
    echo usage:
    echo     %~n0[%~x0] / tag-name
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

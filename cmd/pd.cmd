@echo off

rem pushd/popd helper

if "%~1" equ "" (
    popd
    exit /b 0
)

if "%~1" equ "." (
    echo --- current directory tagging mode ---
    if "%~2" equ "" (
        echo usage:
        echo     %~n0[%~x0] . tag-name
        exit /b 1
    )
    set PD_TAGs[%~2]=%CD%
    set PD_TAGs[%~2] | findstr /b /i /l "PD_TAGs[%~2]="
    exit /b 0
)

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

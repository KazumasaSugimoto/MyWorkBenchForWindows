@echo off

rem pushd/popd helper

if "%~1" equ "" (
    popd
    exit /b 0
)

setlocal EnableDelayedExpansion

set DESTINATION=%~1

if not exist "%DESTINATION%" (
    if defined %DESTINATION% set DESTINATION=!%DESTINATION%!
)

endlocal & pushd "%DESTINATION%"

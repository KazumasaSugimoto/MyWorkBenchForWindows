@echo off

rem -------------------------------------------------------------------------------
rem Add Path (current session only)
rem -------------------------------------------------------------------------------
rem usage:
rem     add-path[.cmd] folder-path

if "%~1" equ "" (
    call bshelp.cmd "%~f0"
    exit /b 1
)

if not exist "%~f1" (
    echo not exist.>&2
    exit /b 1
)

set PATH=%~f1;%PATH%
exit /b 0

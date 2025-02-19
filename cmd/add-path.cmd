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

for /f "usebackq tokens=*" %%a in (`ps.cmd -Command "(Get-Item -Path '%~f1').Mode -like 'd*'"`) do (
    if /i "%%a" neq "true" (
        echo not folder.>&2
        exit /b 1
    )
)

call del-path.cmd "%~f1" 2>nul

set PATH=%~f1;%PATH%
exit /b 0

@echo off

rem Actual Location Displayer

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set TARGET_DRIVE_LETTER=%CD:~0,1%
set COMMON_PATH=%CD:~2%\

if "%~1" equ "" goto SEARCH
if not exist "%~1" (
    echo not exist.>&2
    exit /b 1
)
set TARGET_DRIVE_LETTER=%~d1
set TARGET_DRIVE_LETTER=!TARGET_DRIVE_LETTER:~0,1!
set COMMON_PATH=%~pnx1

:SEARCH

::assigned drive by `subst`.
for /f "usebackq tokens=1,2*" %%a in (`subst`) do (
    if /i "%TARGET_DRIVE_LETTER%:\:" equ "%%a" (
        set ACTUAL_ROOT=%%c
        if /i "!ACTUAL_ROOT:~0,4!" equ "UNC\" set ACTUAL_ROOT=\\!ACTUAL_ROOT:~4!
        echo !ACTUAL_ROOT!%COMMON_PATH%
        exit /b 0
    )
)

::assigned drive by `net use`.
for /f "usebackq tokens=*" %%a in (`powershell "(Get-PSDrive -Name %TARGET_DRIVE_LETTER%).DisplayRoot"`) do (
    if /i "%TARGET_DRIVE_LETTER%:\" neq "%%a" (
        echo %%a%COMMON_PATH%
        exit /b 0
    )
)

echo.%TARGET_DRIVE_LETTER%:%COMMON_PATH%>&2
exit /b 1

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

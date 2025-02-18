@echo off

rem -------------------------------------------------------------------------------
rem Delete Path (current session only)
rem -------------------------------------------------------------------------------
rem usage:
rem     del-path[.cmd] folder-path

if "%~1" equ "" (
    call bshelp.cmd "%~f0"
    exit /b 1
)

setlocal EnableDelayedExpansion

set PATH_EDIT_WORK=;%PATH%;
set PATH_EDIT_WORK=!PATH_EDIT_WORK:;%~f1;=;!

if ";%PATH%;" equ "%PATH_EDIT_WORK%" (
    echo not included.>&2
    exit /b 1
)

set PATH_EDIT_WORK=!PATH_EDIT_WORK:;/;=;!
set PATH_EDIT_WORK=!PATH_EDIT_WORK:~1!
set PATH_EDIT_WORK=!PATH_EDIT_WORK:~0,-1!

endlocal & set PATH=%PATH_EDIT_WORK%
exit /b 0

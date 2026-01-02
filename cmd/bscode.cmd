::? -------------------------------------------------------------------------------
::? Batch Script Code Openner
::? -------------------------------------------------------------------------------
::? usage:
::?     bscode[.cmd] source
::? arguments:
::?     source:
::?         batch script file name or path.

@echo off

setlocal

::= SIMILAR: bshelp.cmd
set SOURCE=%~1
if not defined SOURCE call bshelp.cmd "%~f0" "::?" & exit /b 1
if exist "%SOURCE%" goto SOURCE_DETERMINED

set SOURCE=%~$PATH:1
if exist "%SOURCE%" goto SOURCE_DETERMINED

for /f "usebackq tokens=*" %%a in (`where %1 2^>nul`) do (
    set SOURCE=%%a
    goto SOURCE_DETERMINED
)
echo "%~1" was not found.>&2
exit /b 1

:SOURCE_DETERMINED

call :IS_BATCH_FILE "%SOURCE%"
if ERRORLEVEL 1 (
    echo "%SOURCE%" is not batch file.>&2
    exit /b 1
)

:TRY_OPEN_BY_VSCODE

where code.cmd >nul 2>&1
if ERRORLEVEL 1 goto OPEN_BY_NOTEPAD

call code.cmd "%SOURCE%"
exit /b %ERRORLEVEL%

:OPEN_BY_NOTEPAD

start notepad.exe "%SOURCE%"
exit /b %ERRORLEVEL%

:IS_BATCH_FILE

::= SIMILAR: bshelp.cmd
for /f "usebackq tokens=*" %%x in (`echor.cmd .bat .cmd`) do if /i "%~x1" equ "%%x" exit /b 0
exit /b 1

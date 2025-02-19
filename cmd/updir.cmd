@echo off

rem -------------------------------------------------------------------------------
rem Upstream Dir - the opposite of `dir /s`
rem -------------------------------------------------------------------------------
rem
rem usage:
rem
rem     updir[.cmd] [path]file-name
rem
rem example:
rem
rem     updir .gitignore

if "%~1" equ "" goto SHOW_HELP
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set RAW_ARG1=%~1
if "%RAW_ARG1%" equ "%RAW_ARG1:\=%" (
    set BASE_FOLDER=%CD%
    set SCAN_PATTERN=%RAW_ARG1%
) else (
    set BASE_FOLDER=%~dp1
    set SCAN_PATTERN=!RAW_ARG1:%~dp1=!
)
pushd "%BASE_FOLDER%"

:SCAN_CURRENT_FOLDER

for /f "usebackq tokens=*" %%a in (`dir /a-d /b "%SCAN_PATTERN%" 2^>nul`) do echo %CD%\%%a

set SCANED_DIR=%CD%
cd ..

if "%SCANED_DIR%" neq "%CD%" goto SCAN_CURRENT_FOLDER

popd
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:SHOW_HELP

call bshelp.cmd "%~f0"
exit /b 1

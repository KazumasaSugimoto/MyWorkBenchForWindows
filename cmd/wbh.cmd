@echo off

rem Web Browse History

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal EnableDelayedExpansion

set SQL_FILE_PATH=%~dp0conf\%~n0.sql
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-sql -sql /sql :sql`) do if /i "%~1" equ "%%a" goto EDIT_SQL

echo -------------------------------------------------------------------------------
echo Web Browse History
echo -------------------------------------------------------------------------------

where sqlite3 >nul 2>&1
if ERRORLEVEL 1 (
    echo "sqlite3" is required to execute this script.
    echo How to install:
    echo    winget install SQLite.SQLite
    echo      or
    echo    scoop install sqlite 
    exit /b 1
)

:SHOW_MENU_FOR_SELECT_BROWSER

echo.
echo Select Browser:
echo     1. Microsoft Edge
echo     2. Google Chrome
echo    -1. Exit

:SELECT_BROWSER

set ANS_NUM=
set /p ANS_NUM="? > "
set /a ANS_NUM+=0

if %ANS_NUM% lss 0 exit /b 0
set BROWSER_PROFILE_PATH=
if %ANS_NUM% equ 1 set BROWSER_PROFILE_PATH=%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\
if %ANS_NUM% equ 2 set BROWSER_PROFILE_PATH=%USERPROFILE%\AppData\Local\Google\Chrome\User Data\
if not defined BROWSER_PROFILE_PATH goto SELECT_BROWSER

:SHOW_MENU_FOR_SELECT_PROFILE

echo.
echo Select Profile:

set PROFILES_COUNT=0

pushd "%BROWSER_PROFILE_PATH%"
for /f "usebackq tokens=*" %%a in (`dir /b /s History`) do (
    set /a PROFILES_COUNT+=1
    set PROFILE_NAME=%%~dpa
    set PROFILE_NAME=!PROFILE_NAME:%BROWSER_PROFILE_PATH%=!
    set PROFILE_NAME=!PROFILE_NAME:~0,-1!
    echo     !PROFILES_COUNT!. !PROFILE_NAME!
    set PROFILE_NAMES[!PROFILES_COUNT!]=!PROFILE_NAME!
)
popd
echo    -1. Exit

:SELECT_PROFILE

set ANS_NUM=
set /p ANS_NUM="? > "
set /a ANS_NUM+=0

if %ANS_NUM% lss 0 exit /b 0
if %ANS_NUM% equ 0 goto SELECT_PROFILE
if %ANS_NUM% gtr %PROFILES_COUNT% goto SELECT_PROFILE

:SHOW_MENU_FOR_SELECT_OUTPUT_MEHTOD

echo.
echo Select Output Method:
echo     1. Default browser
echo     2. Excel
echo    -1. Exit

:SELECT_OUTPUT_METHOD

set ANS_NUM=
set /p ANS_NUM="? > "
set /a ANS_NUM+=0

if %ANS_NUM% lss 0 exit /b 0
set OUTPUT_MEHOD=
if %ANS_NUM% equ 1 set OUTPUT_METHOD=.www
if %ANS_NUM% equ 2 set OUTPUT_METHOD=.excel
if not defined OUTPUT_METHOD goto SELECT_OUTPUT_METHOD

:PUT_HISTORY

set BROWSER_HISTORY_PATH=%BROWSER_PROFILE_PATH%!PROFILE_NAMES[%ANS_NUM%]!\History
set HISTORY_CLONE_PATH=%TEMP%\History.Snapshot

copy "%BROWSER_HISTORY_PATH%" "%HISTORY_CLONE_PATH%" >nul

sqlite3 "%HISTORY_CLONE_PATH%" "%OUTPUT_METHOD%" ".read '%SQL_FILE_PATH%'"

del "%HISTORY_CLONE_PATH%"

exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:EDIT_SQL

call code.cmd "%SQL_FILE_PATH%"
exit /b 0

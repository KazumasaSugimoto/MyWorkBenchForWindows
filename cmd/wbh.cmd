@echo off

rem Web Browse History

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es  /es  :es` ) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-sql  -sql /sql :sql`) do if /i "%~1" equ "%%a" goto EDIT_SQL

setlocal EnableDelayedExpansion

echo -------------------------------------------------------------------------------
echo Web Browse History
echo -------------------------------------------------------------------------------

:SHOW_MENU_FOR_SELECT_BROWSER

echo.
echo Select browser:
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

:PUT_HISTORY

set BROWSER_HISTORY_PATH=%BROWSER_PROFILE_PATH%!PROFILE_NAMES[%ANS_NUM%]!\History
set HISTORY_CLONE_PATH=%TEMP%\History.Snapshot

copy "%BROWSER_HISTORY_PATH%" "%HISTORY_CLONE_PATH%" >nul

set /p SQL=<"%~dp0conf\%~n0.sql"
sqlite3 "%HISTORY_CLONE_PATH%" ".www" "%SQL%"

del "%HISTORY_CLONE_PATH%"

exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:EDIT_SQL

call code.cmd "%~dp0conf\%~n0.sql"
exit /b 0

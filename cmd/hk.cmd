@echo off

setlocal

for /f "usebackq tokens=*" %%a in (`echov --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=*" %%a in (`echov --edit-code -ec /ec :ec`) do if /i "%~1" equ "%%a" goto EDIT_CODE

for /f "usebackq tokens=*" %%a in (`echov ver1 v1 1`) do if /i "%~1" equ "%%a" goto START_V1
for /f "usebackq tokens=*" %%a in (`echov ver2 v2 2`) do if /i "%~1" equ "%%a" goto START_V2

echo -------------------------------------------------------------------------------
echo Start AutoHotkey
echo -------------------------------------------------------------------------------

:ASK_VER

set VER_NO=
set /p VER_NO="version? > "
set /a VER_NO+=0

if %VER_NO% equ 1 goto START_V1
if %VER_NO% equ 2 goto START_V2
goto ASK_VER

:START_V1

start "AutoHotKey V1" /D"C:\Program Files\AutoHotkey\" AutoHotkeyU64_UIA.exe "%USERPROFILE%\Documents\AutoHotKey.ahk"
exit /b 0

:START_V2

start "AutoHotKey V2" /D"C:\Program Files\AutoHotkey\v2\" AutoHotkey64_UIA.exe "%USERPROFILE%\Documents\AutoHotKeyV2.ahk"
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:EDIT_CODE

call code.cmd "%USERPROFILE%\Documents\AutoHotKeyV2.ahk"
exit /b 0

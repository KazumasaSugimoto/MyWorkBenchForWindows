@echo off

setlocal

set BIN_FOLDER=C:\Program Files\AutoHotkey\
set SRC_FOLDER=%~dp0..\conf\ahk\

set OPTS_EDIT_SELF=--edit-self -es /es :es
set OPTS_EDIT_CODE=--edit-code -ec /ec :ec

for /f "usebackq tokens=*" %%a in (`echor.cmd %OPTS_EDIT_SELF%`) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=*" %%a in (`echor.cmd %OPTS_EDIT_CODE%`) do if /i "%~1" equ "%%a" goto EDIT_CODE

set OPTS_VER1=ver1 v1 1
set OPTS_VER2=ver2 v2 2

for /f "usebackq tokens=*" %%a in (`echor.cmd %OPTS_VER1%`) do if /i "%~1" equ "%%a" goto START_V1
for /f "usebackq tokens=*" %%a in (`echor.cmd %OPTS_VER2%`) do if /i "%~1" equ "%%a" goto START_V2

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

start "AutoHotKey V1" /D"%BIN_FOLDER%" AutoHotkeyU64_UIA.exe "%SRC_FOLDER%AutoHotKey.ahk"
exit /b 0

:START_V2

start "AutoHotKey V2" /D"%BIN_FOLDER%v2\" AutoHotkey64_UIA.exe "%SRC_FOLDER%AutoHotKeyV2.ahk"
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:EDIT_CODE

call code.cmd "%SRC_FOLDER%AutoHotKeyV2.ahk"
exit /b 0

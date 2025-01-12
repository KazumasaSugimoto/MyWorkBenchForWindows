@echo off

for /f "usebackq tokens=1" %%a in (`echov --edit /edit :edit`) do if /i "%~1" equ "%%a" goto EDIT

rem start /D"C:\Program Files\AutoHotkey\" AutoHotkey.exe
start "Launch AutoHotKey" /D"C:\Program Files\AutoHotkey\" AutoHotkeyU64_UIA.exe "%USERPROFILE%\Documents\AutoHotKey.ahk"
goto :EOF

:EDIT
call code.cmd "%~f0"
goto :EOF

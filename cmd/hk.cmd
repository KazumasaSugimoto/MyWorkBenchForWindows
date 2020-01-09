@echo off

if /i "%~1" equ "edit" goto EDIT

start /D"C:\Program Files\AutoHotkey\" AutoHotkey.exe
goto :EOF

:EDIT
start notepad %~f0
goto :EOF

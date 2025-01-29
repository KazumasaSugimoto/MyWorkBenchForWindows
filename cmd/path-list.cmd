@echo off

for /f "usebackq tokens=*" %%a in (`echov.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal

if "%~1" equ "" (
    set PATH_VAR_OR_STR=$env:PATH
    goto DO_MAIN
)
for /f "usebackq tokens=1 delims==" %%a in (`set ^| findstr /B /I "%~1="`) do (
    set PATH_VAR_OR_STR=$env:%%a
    goto DO_MAIN
)
set PATH_VAR_OR_STR='%~1'

:DO_MAIN

powershell (%PATH_VAR_OR_STR%) -split ';' -ne ''
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

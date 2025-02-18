@echo off

rem -------------------------------------------------------------------------------
rem Path String Splitter
rem -------------------------------------------------------------------------------
rem 
rem usage:
rem 
rem     path-list[.cmd] [ environment-variable | path-string ]
rem 
rem example:
rem 
rem     path-list
rem 
rem        same result:
rem            path-list PATH
rem            path-list "%PATH%"
rem 
rem     path-list ";path1;;path2;;;path3;;;;"
rem 
rem        path1
rem        path2
rem        path3

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=*" %%a in (`echor.cmd --help -? /? :?`        ) do if /i "%~1" equ "%%a" goto SHOW_HELP

setlocal

set PATH_VAR_OR_STR=$env:PATH
if "%~1" equ "" goto DO_MAIN

for /f "usebackq tokens=1 delims==" %%a in (`set ^| findstr /B /I "%~1="`) do (
    set PATH_VAR_OR_STR=$env:%%a
    goto DO_MAIN
)
set PATH_VAR_OR_STR='%~1'

:DO_MAIN

::: v1:
:::     powershell $env:PATH -split ';'
::: v2:
:::     powershell ($env:PATH).Trim(';') -replace ';;',';' -split ';'
::: v3:
powershell (%PATH_VAR_OR_STR%) -split ';' -ne ''
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:SHOW_HELP

call bshelp.cmd "%~f0"
exit /b 1

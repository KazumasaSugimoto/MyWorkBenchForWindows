@echo off

for /f "usebackq tokens=*" %%a in (`echov.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=*" %%a in (`echov.cmd --help -? /? :?`        ) do if /i "%~1" equ "%%a" goto SHOW_HELP

setlocal

set PATH_VAR_OR_STR=$env:PATH
if "%~1" equ "" goto DO_MAIN

for /f "usebackq tokens=1 delims==" %%a in (`set ^| findstr /B /I "%~1="`) do (
    set PATH_VAR_OR_STR=$env:%%a
    goto DO_MAIN
)
set PATH_VAR_OR_STR='%~1'

:DO_MAIN

rem v1:
rem     powershell $env:PATH -split ';'
rem v2:
rem     powershell ($env:PATH).Trim(';') -replace ';;',';' -split ';'
rem v3:
powershell (%PATH_VAR_OR_STR%) -split ';' -ne ''
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

:SHOW_HELP

echo -------------------------------------------------------------------------------
echo Path String Splitter
echo -------------------------------------------------------------------------------
echo.
echo usage:
echo.
echo     %~n0[%~x0] [ environment-variable ^| path-string ]
echo.
echo example:
echo.
echo     %~n0
echo.
echo        same result:
echo            %~n0 PATH
echo            %~n0 "%%PATH%%"
echo.
echo     %~n0 ";path1;;path2;;;path3;;;;"
echo.
echo        path1
echo        path2
echo        path3

exit /b 1

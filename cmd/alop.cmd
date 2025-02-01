@echo off

rem Actual Location Opener

for /f "usebackq tokens=*" %%a in (`echov.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal

set ACTUAL_LOCATION=
for /f "usebackq tokens=*" %%a in (`aldp.cmd %1 2^>nul`) do (
    set ACTUAL_LOCATION=%%a
    goto DETECTED
)
echo no need open or can't be opened.>&2
echo because that's it or does not exist.>&2
exit /b 1

:DETECTED

start "Open actual location" "%ACTUAL_LOCATION%"
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

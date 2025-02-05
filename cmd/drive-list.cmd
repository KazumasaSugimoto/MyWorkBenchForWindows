@echo off

rem Outputs assigned drive list.

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal

set FOREACH_CMD=powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceId, Description | Format-Table -HideTableHeaders"
for /f "usebackq tokens=1*" %%a in (`%FOREACH_CMD%`) do (
    call :PUT_DRIVE_INFO "%%a" "%%b"
)
exit /b 0

:PUT_DRIVE_INFO

set DEVICE_ID=%~1
set DESCRIPTION=%~2
call :GET_SET_CURRENT_DIRECTORY

echo %DEVICE_ID% %DESCRIPTION% %CURDIR_OR_ERRMSG%
goto :EOF

:GET_SET_CURRENT_DIRECTORY

set CURDIR_OR_ERRMSG=
for /f "usebackq tokens=*" %%e in (`pushd "%DEVICE_ID%" 2^>^&1`) do set CURDIR_OR_ERRMSG=%%e
if defined CURDIR_OR_ERRMSG goto :EOF

pushd "%DEVICE_ID%"
set CURDIR_OR_ERRMSG=%CD%
popd
goto :EOF

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

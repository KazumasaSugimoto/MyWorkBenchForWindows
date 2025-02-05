@echo off

rem Outputs assigned drive list.

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal

set FOREACH_CMD=powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceId, Description | Format-Table -HideTableHeaders"
for /f "usebackq tokens=1*" %%a in (`%FOREACH_CMD%`) do (
    echo %%a %%b
)
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

@echo off

rem Outputs assigned drive list.

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

setlocal

set WITH_CURDIR=
for /f "usebackq tokens=*" %%a in (`echor.cmd --cur-dir -cd /cd :cd`) do if /i "%~1" equ "%%a" set WITH_CURDIR=True

set FOREACH_CMD=powershell "Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceId, DriveType, Description | Format-Table -HideTableHeaders"
for /f "usebackq tokens=1,2*" %%a in (`%FOREACH_CMD%`) do (
    call :PUT_DRIVE_INFO "%%a" "%%b" "%%c"
)
exit /b 0

:PUT_DRIVE_INFO

set DEVICE_ID=%~1
set DRIVE_TYPE=%~2
set DESCRIPTION=%~3

call :UPDATE_DESCRIPTION_OF_DRIVE_TYPE_%DRIVE_TYPE%

set CURDIR_OR_ERRMSG=
if defined WITH_CURDIR call :GET_SET_CURRENT_DIRECTORY

echo %DEVICE_ID% %DESCRIPTION% %CURDIR_OR_ERRMSG%
goto :EOF

:UPDATE_DESCRIPTION_OF_DRIVE_TYPE_2     ::Removable
:UPDATE_DESCRIPTION_OF_DRIVE_TYPE_5     ::CD Drive

goto :EOF

:UPDATE_DESCRIPTION_OF_DRIVE_TYPE_3     ::HDD
:UPDATE_DESCRIPTION_OF_DRIVE_TYPE_4     ::Network Drive

for /f "usebackq tokens=*" %%a in (`aldp.cmd "%DEVICE_ID%\" 2^>nul`) do set DESCRIPTION=%%a
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

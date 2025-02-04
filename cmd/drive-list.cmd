@echo off

rem Outputs assigned drive list.

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

for /f "usebackq tokens=*" %%a in (`echov.cmd ABCDEFGHIJKLMNOPQRSTUVWXYZ`) do (
    pushd "%%a:\" 2>nul
    if not ERRORLEVEL 1 (
        echo %%a:
        popd
    )
)
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

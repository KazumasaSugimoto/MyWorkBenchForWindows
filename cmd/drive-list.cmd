@echo off

rem Outputs assigned drive list.

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

for %%a in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do (
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

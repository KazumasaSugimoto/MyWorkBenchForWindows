@echo off

rem prompt command helper.

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

for /f "usebackq tokens=*" %%a in (`echor.cmd --help -? /? :?`) do if /i "%~1" equ "%%a" (
    prompt /?
    exit /b 0
)

:: my default
if "%~1" equ "" (
    prompt $P$S$+$_$G$S
    exit /b 0
)

:: system default
for /f "usebackq tokens=*" %%a in (`echor.cmd --default -def /def :def`) do if /i "%~1" equ "%%a" (
    prompt $P$G
    exit /b 0
)

prompt %~1
exit /b 0

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

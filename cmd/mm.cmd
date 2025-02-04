@echo off

setlocal EnableDelayedExpansion

set template_path=%~dp0conf\%~n0.form

for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-form -ef /ef :ef`) do if /i "%~1" equ "%%a" goto EDIT_FORM
for /f "usebackq tokens=*" %%a in (`echor.cmd --edit-path -ep /ep :ep`) do if /i "%~1" equ "%%a" goto EDIT_PATH

:SEARCH

set cnt=0
for /f "usebackq tokens=1*" %%a in ("%~dp0conf\%~n0.path-list.ssv") do (
    set file_path=%%~a\%~1.md
    call :CHECK_EXIST !file_path!
    if "!flg!" equ "true" (
        call :EDIT !file_path!
        exit /b 0
    )
    set /a cnt+=1
rem set file_path[!cnt!]=%%~fa      HINT NG-CODE because expansion of env-var(ex. %USERPROFILE%) fails.
    call :SET_PATH_LIST !cnt! %%a
)

:MENU

cls
for /l %%i in (1,1,%cnt%) do (
    echo %%i. !file_path[%%i]!
)

:CHOICE

set /p n="? > "
if /i "%n%" equ "q" goto :EOF
if /i "%n%" equ "x" goto :EOF

:MATCHING

set file_path=!file_path[%n%]!
if "%file_path%" neq "" (
    set file_path=%file_path%\%~1.md
    call :COPY_TEMPLATE "!file_path!"
    call :EDIT "!file_path!"
    exit /b 0
)
goto CHOICE

:EDIT
call code.cmd "%~1"
goto :EOF

:EDIT_FORM
call code.cmd "%template_path%"
exit /b 0

:EDIT_SELF
call code.cmd "%~f0"
exit /b 0

:EDIT_PATH
call code.cmd "%~dp0conf\%~n0.path-list.ssv"
exit /b 0

:CHECK_EXIST
if exist "%~1" (
    set flg=true
) else (
    set flg=false
)
goto :EOF

:COPY_TEMPLATE
copy "%template_path%" "%~1"
goto :EOF

:SET_PATH_LIST
set file_path[%~1]=%~2
goto :EOF

@echo off

setlocal EnableDelayedExpansion

set template_path=%~dpn0.form

if /i "%1" equ "edit" goto EDIT_SELF
if /i "%1" equ "form" goto EDIT_FORM

:SEARCH
set cnt=0
for /f "tokens=1*" %%a in (%~dpn0.path-list.ssv) do (
    set file_path=%%~a\%~1.md
    call :CHECK_EXIST !file_path!
    if "!flg!" equ "true" (
        call :EDIT !file_path!
        goto :EOF
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
set /p n="?>"
if /i "%n%" equ "q" goto :EOF
if /i "%n%" equ "x" goto :EOF

:MATCHING
set file_path=!file_path[%n%]!
if "%file_path%" neq "" (
    set file_path=%file_path%\%~1.md
    call :COPY_TEMPLATE "!file_path!"
    call :EDIT "!file_path!"
    goto :EOF
)
goto CHOICE

:EDIT
rem start vsc.cmd "%~1"
call code.cmd "%~1"
goto :EOF

:EDIT_FORM
rem start vsc.cmd "%template_path%"
call code.cmd "%template_path%"
goto :EOF

:EDIT_SELF
rem start vsc.cmd "%~f0"
call code.cmd "%~f0"
goto :EOF

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

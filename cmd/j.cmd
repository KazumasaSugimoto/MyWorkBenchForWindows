@echo off
rem このファイルの文字コードはShift-JISです。

:BEGIN
if /i "%1" equ ""     goto PROMPT
if /i "%1" equ "edit" goto EDIT
if /i "%1" equ "list" goto EDIT_LIST

for /F "skip=2 tokens=1,2*" %%a in ('find /i "%1" %~dpn0.lst') do (
    if /i "%1" equ "%%a" (
        call :%%b_CASE "%%c"
    )    
)
goto :EOF

:IGNORE_CASE
goto :EOF

:DEFAULT_CASE
start %~1
goto :EOF

:EXPLORER_CASE
explorer %1
goto :EOF

:PROMPT
set /p KEY="jump?>"
call j.cmd %KEY%
goto :EOF

:EDIT
start notepad %~f0
goto :EOF

:EDIT_LIST
start notepad %~dpn0.lst
goto :EOF

@echo off

:BEGIN
if /i "%~1" equ "" goto PROMPT

for /f "usebackq tokens=1" %%a in (`echor.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF
for /f "usebackq tokens=1" %%a in (`echor.cmd --edit-list -el /el :el`) do if /i "%~1" equ "%%a" goto EDIT_LIST

for /f "usebackq eol=# tokens=1,2*" %%a in (`find /i "%~1" "%~dp0conf\%~n0.lst"`) do (
    if /i "%~1" equ "%%a" (
        call :%%b_CASE "%%c"
    )    
)
goto :EOF

:IGNORE_CASE
goto :EOF

:DEFAULT_CASE
start "Start" %~1
goto :EOF

:EXPLORER_CASE
explorer "%~1"
goto :EOF

:PROMPT
set /p KEY="jump ? > "
call j.cmd %KEY%
goto :EOF

:EDIT_SELF
call code.cmd "%~f0"
goto :EOF

:EDIT_LIST
call code.cmd "%~dp0conf\%~n0.lst"
goto :EOF

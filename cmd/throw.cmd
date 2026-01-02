::? -------------------------------------------------------------------------------
::? Throw(Send) each file extension to dedicated batch processing.
::? -------------------------------------------------------------------------------
::? usage:
::?     throw[.cmd] file-path

@echo off

setlocal

set FULLPATH=%~f1
set EXTENSION=%~x1

if not defined EXTENSION (
    echo extension nothing.
)

set PROC_BATCH_PATH=
for /f "usebackq tokens=*" %%a in (`updir.cmd "%EXTENSION:~1%.proc.cmd"`) do (
    set PROC_BATCH_PATH=%%a
)
if defined PROC_BATCH_PATH goto PROC_BATCH_DETECTED

echo process batch not found.>&2
echo use "%EXTENSION%"'s default?
echo ( = start "%FULLPATH%" )

set ASK_YN_ANS=N
set /p ASK_YN_ANS="y/[N] ? > "

if /i "%ASK_YN_ANS%" neq "n" (
    echo cancelled.
    exit /b 1
)

start "start %EXTENTION%" "%FULLPATH%"
exit /b %ERRORLEVEL%

:PROC_BATCH_DETECTED

call "%PROC_BATCH_PATH%" "%FULLPATH%"
exit /b %ERRORLEVEL%

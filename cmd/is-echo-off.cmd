::? -------------------------------------------------------------------------------
::? Echo OFF State Checker
::? -------------------------------------------------------------------------------
::? usage:
::?     is-echo-off[.cmd]
::? errorlevel:
::?     0: true (`echo off`) | 1: false (`echo on`)
@setlocal
@call lluid.cmd LLUID >nul
@set TEMP_FILE_PATH=%TEMP%\%~nx0.result.tmp
@echo >"%TEMP_FILE_PATH%"
::? tested code pages:
::?     932   - Shift JIS
::?     65001 - UTF-8
@findstr /IL "off. <OFF>" "%TEMP_FILE_PATH%" >nul 2>&1 && (set RESULT=0) || (set RESULT=1)
@del "%TEMP_FILE_PATH%"
@if "%~1" neq "" (
    call bshelp.cmd "%~f0" "::?"
    echo result:
    echo     %RESULT%
)
@endlocal & exit /b %RESULT%
::! implemantation caution:
::!     NG: echo | findstr ... -> always 'on'.
::!     OK: echo >"temp-file" & findstr ... "temp-file"
::!     verification steps:
::!         1. echo on  & echo | more
::!         2. echo off & echo | more
::!         3. echo on  & echo >dummy.txt & more dummy.txt
::!         4. echo off & echo >dummy.txt & more dummy.txt

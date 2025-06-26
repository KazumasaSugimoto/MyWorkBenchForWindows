::? -------------------------------------------------------------------------------
::? Echo OFF State Checker
::? -------------------------------------------------------------------------------
::? usage:
::?     is-echo-off[.cmd]
::? errorlevel:
::?     0: true (echo is off) | 1: false (echo is on)
@setlocal
@call lluid.cmd LLUID >nul
@set ECHO_STATE=%TEMP%\%~nx0.%LLUID%.result.tmp
@echo >"%ECHO_STATE%"
::? tested code pages:
::?     932   - Shift JIS
::?     65001 - UTF-8
@findstr /IL "off. <OFF>" "%ECHO_STATE%" >nul 2>&1 && (set RESULT=0) || (set RESULT=1)
@del "%ECHO_STATE%"
@if "%~1" neq "" (
    call bshelp.cmd "%~f0" "::?"
    echo result:
    echo     %RESULT%
)
@endlocal & exit /b %RESULT%
::! implementation caution:
::!     NG: `echo | findstr ...` -> always 'on'.
::!     OK: `echo >"temp-file" & findstr ... "temp-file"`
::!     verification steps:
::!         1. `echo on  & echo | more`
::!         2. `echo off & echo | more`
::!         3. `echo on  & echo >dummy.txt & more dummy.txt`
::!         4. `echo off & echo >dummy.txt & more dummy.txt`

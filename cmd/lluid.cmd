::? -------------------------------------------------------------------------------
::? Local L[ax|oose] Unique ID (nearly timestamp)
::? -------------------------------------------------------------------------------
::? usage:
::?     lluid[.cmd] [retvar-name]
::? id format:
::?     yyyymmdd.hhmmss.ff.nnnnn
::? example:
::?     lluid
::?       or
::?     lluid ID >nul
::?     echo %ID%

@setlocal
@set /a LLUID=100000+%RANDOM%
@set LLUID=%DATE:/=%.%TIME::=%.%LLUID:~1%
@set LLUID=%LLUID:-=%
@set LLUID=%LLUID: =0%
@echo %LLUID%
@endlocal & if "%~1" neq "" set %~1=%LLUID%

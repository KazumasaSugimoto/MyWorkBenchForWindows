::? -------------------------------------------------------------------------------
::? Current Code Page
::? -------------------------------------------------------------------------------
::? usage:
::?     ccp[.cmd] [retvar-name]
@setlocal
@call lluid.cmd LLUID >nul
@set TEMP_FILE_PATH=%TEMP%\%~nx0.%LLUID%.result.tmp
@chcp >"%TEMP_FILE_PATH%"
@set /p TEMP_FILE_ROW=<"%TEMP_FILE_PATH%"
@for /f "usebackq tokens=*" %%a in (`echor.cmd %TEMP_FILE_ROW%`) do @set RESULT=%%a
@echo %RESULT%
@del "%TEMP_FILE_PATH%"
@endlocal & if "%~1" neq "" set %~1=%RESULT%

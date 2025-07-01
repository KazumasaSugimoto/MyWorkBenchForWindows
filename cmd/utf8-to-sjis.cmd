::? -------------------------------------------------------------------------------
::? UTF-8 to Shift JIS
::? -------------------------------------------------------------------------------
::? usage:
::?		other command's stdout | utf8-to-sjis[.cmd]
@setlocal
@call lluid.cmd LLUID >nul
@set TEMP_FILE_PATH=%TEMP%\%~nx0.%LLUID%.tmp
@findstr /R ".*" >"%TEMP_FILE_PATH%"
@powershell -NoProfile -Command "Get-Content -LiteralPath '%TEMP_FILE_PATH%' -Encoding UTF8"
@set PS_RESULT=%ERRORLEVEL%
@del "%TEMP_FILE_PATH%"
@endlocal & exit /b %PS_RESULT%


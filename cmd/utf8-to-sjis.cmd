::? -------------------------------------------------------------------------------
::? UTF-8 to Shift JIS
::? -------------------------------------------------------------------------------
::? usage:
::?     other command's stdout | utf8-to-sjis[.cmd] [--ignore-bom]

@if /i "%~1" equ "--ignore-bom" goto TRY_PLAN_C

:TRY_PLAN_A

@where iconv >nul 2>&1
@if ERRORLEVEL 1 goto TRY_PLAN_B

@iconv -f UTF-8 -t SJIS
@exit /b %ERRORLEVEL%

:TRY_PLAN_B

@where busybox >nul 2>&1
@if ERRORLEVEL 1 goto TRY_PLAN_C

@busybox iconv -f UTF-8 -t SJIS
@exit /b %ERRORLEVEL%

:TRY_PLAN_C

@setlocal
@call lluid.cmd LLUID >nul
@set TEMP_FILE_PATH=%TEMP%\%~nx0.%LLUID%.tmp
@findstr /R ".*" >"%TEMP_FILE_PATH%"
@powershell -NoProfile -Command "Get-Content -LiteralPath '%TEMP_FILE_PATH%' -Encoding UTF8"
@set PS_ERRORLEVEL=%ERRORLEVEL%
@del "%TEMP_FILE_PATH%"
@endlocal & exit /b %PS_ERRORLEVEL%

::? -------------------------------------------------------------------------------
::? Indent
::? -------------------------------------------------------------------------------
::? usage:
::?     other command's stdout | indent[.cmd] length
::?       or
::?     indent[.cmd] length <"text-file-path"

@if "%~1" equ "" exit /b 1

@setlocal

@set LENGTH=%~1
@set /a LENGTH+=0

@call lluid.cmd LLUID >nul
@set TEMP_FILE_PATH=%TEMP%\%~nx0.LLUID.tmp

@findstr /R ".*" >"%TEMP_FILE_PATH%"

@set PSCMD=^
Get-Content -LiteralPath '%TEMP_FILE_PATH%' -Encoding OEM ^| ^
ForEach-Object { ('{0,%LENGTH%}{1}' -f '', $_) }
@powershell -NoProfile -Command "%PSCMD%"

@del "%TEMP_FILE_PATH%"

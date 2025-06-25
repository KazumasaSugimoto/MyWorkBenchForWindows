::? -------------------------------------------------------------------------------
::? Indent
::? -------------------------------------------------------------------------------
::? usage:
::?     other command's stdout | indent[.cmd] depth
::?       or
::?     indent[.cmd] depth <"text-file-path"
::? arguments:
::?     depth:
::?         indent length. (byte)

@if "%~1" equ "" call bshelp.cmd "%~f0" "::?" & exit /b 1

@setlocal

@set DEPTH=%~1
@set /a DEPTH+=0

@call lluid.cmd LLUID >nul
@set TEMP_FILE_PATH=%TEMP%\%~nx0.%LLUID%.tmp

@findstr /R ".*" >"%TEMP_FILE_PATH%"

@set PSCMD=^
Get-Content -LiteralPath '%TEMP_FILE_PATH%' -Encoding OEM ^| ^
ForEach-Object { ('{0,%DEPTH%}{1}' -f '', $_) }
@powershell -NoProfile -Command "%PSCMD%"

@del "%TEMP_FILE_PATH%"

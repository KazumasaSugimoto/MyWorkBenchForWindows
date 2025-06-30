::? -------------------------------------------------------------------------------
::? Batch Script Help Part Displayer
::? -------------------------------------------------------------------------------
::? usage:
::?     bshelp[.cmd] source [preamble ...]
::? arguments:
::?     source:
::?         batch script file path.
::?     preamble[s]:
::?         help row preamble. multiple possible.
::?         (default `rem` and `::?`. but in the future, plan to only use `::?`.)

@setlocal EnableDelayedExpansion

@set ME=%~f0
@set SOURCE=%~1
@if not defined SOURCE call "%ME%" "%ME%" "::?" & exit /b 1
@if exist "%SOURCE%" goto SOURCE_DETERMINED

@set SOURCE=%~$PATH:1
@if exist "%SOURCE%" goto SOURCE_DETERMINED

@for /f "usebackq tokens=*" %%a in (`where %1 2^>nul`) do @((set SOURCE=%%a) & goto SOURCE_DETERMINED)

@echo "%~1" not found.>&2
@exit /b 1

:SOURCE_DETERMINED

@call :IS_BATCH_FILE "%SOURCE%"
@if ERRORLEVEL 1 (
    echo "%SOURCE%" is not batch file.>&2
    exit /b 1
)

@set PREAMBLE=%~2
@if not defined PREAMBLE call "%ME%" "%SOURCE%" "rem" "::?" & exit /b 0

:PREAMBLE_DETERMINED

@if defined USE_OLD_VERSION (call :OLD_VERSION) else (call :NEW_VERSION)
@shift /2
@set PREAMBLE=%~2
@if defined PREAMBLE goto PREAMBLE_DETERMINED
@exit /b 0

:NEW_VERSION

@call lluid.cmd LLUID >nul
@set CONDITIONS=%TEMP%\%~nx0.%LLUID%.tmp
@type nul>"%CONDITIONS%"

@echo.^^ *%PREAMBLE%$>>"%CONDITIONS%"
@echo.^^ *%PREAMBLE% .*$>>"%CONDITIONS%"

@call strlen.cmd "%PREAMBLE%" LENGTH >nul
@set /a OFFSET=LENGTH+1
@for /f "usebackq tokens=*" %%a in (`findstr /IRG:"%CONDITIONS%" "%SOURCE%"`) do @(
    set HELP=%%a
    echo.!HELP:~%OFFSET%!
)
@del "%CONDITIONS%"
@exit /b 0

:OLD_VERSION

@set PSCMD=^
$preamble = [System.Text.RegularExpressions.Regex]::Escape('%PREAMBLE%'); ^
Get-Content -LiteralPath '%SOURCE%' -Encoding OEM ^| ^
ForEach-Object { ^
if ($_ -match """^^\s*$preamble( (?^<HelpMessage^>.*))?$""") { ^
Write-Output ('{0}' -f $Matches['HelpMessage']) ^
} ^
}
:: don't use `ps.cmd` because response speed is priority.
@powershell -NoProfile -Command "%PSCMD%"
@exit /b %ERRORLEVEL%

:IS_BATCH_FILE

@for /f "usebackq tokens=*" %%x in (`echor.cmd .bat .cmd`) do @if /i "%~x1" equ "%%x" exit /b 0
@exit /b 1

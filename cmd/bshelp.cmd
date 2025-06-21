::? -------------------------------------------------------------------------------
::? Batch Script Help Part Displayer
::? -------------------------------------------------------------------------------
::? usage:
::?     bshelp[.cmd] source [preamble]
::? arguments:
::?     source:
::?         batch script file path.
::?     preamble:
::?         help row preamble. (default `rem`)

@setlocal EnableDelayedExpansion

@set SOURCE=%~1
@if not defined SOURCE call "%~f0" "%~f0" "::?" & exit /b 1

@set PREAMBLE=%~2
@if not defined PREAMBLE set PREAMBLE=rem

@if defined USE_OLD_VERSION goto OLD_VERSION

:NEW_VERSION

@call strlen.cmd "%PREAMBLE%" LENGTH >nul
@set /a OFFSET=LENGTH+1
@for /f "usebackq tokens=*" %%a in (`findstr /IRC:"^ *%PREAMBLE% *.*$" "%SOURCE%"`) do @(
    set HELP=%%a
    echo.!HELP:~%OFFSET%!
)
@exit /b 0

:OLD_VERSION

@set PSCMD=^
$preamble = [System.Text.RegularExpressions.Regex]::Escape('%PREAMBLE%'); ^
Get-Content -LiteralPath '%SOURCE%' -Encoding OEM ^| ^
ForEach-Object { ^
if ($_ -match """^^\s*$preamble( ?(?^<HelpMessage^>.*))""") { ^
Write-Output $Matches['HelpMessage'] ^
} ^
}
:: don't use `ps.cmd` because response speed is priority.
@powershell -NoProfile -Command "%PSCMD%"
@exit /b %ERRORLEVEL%

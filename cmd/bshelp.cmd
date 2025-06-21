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

@setlocal

@set SOURCE=%~1
@if not defined SOURCE call "%~f0" "%~f0" "::?" & exit /b 1

@set PREAMBLE=%~2
@if not defined PREAMBLE set PREAMBLE=rem

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

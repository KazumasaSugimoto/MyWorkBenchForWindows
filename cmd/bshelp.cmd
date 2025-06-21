@echo off

rem Batch Script Help Part Displayer

setlocal
set PSCMD=^
Get-Content -LiteralPath '%~1' -Encoding OEM ^| ^
ForEach-Object { ^
if ($_ -match '^^\s*@?rem( ?(?^<HelpMessage^>.*))') { ^
Write-Output $Matches['HelpMessage'] ^
} ^
}
:: don't use `ps.cmd` because response speed is priority.
powershell -NoProfile -Command "%PSCMD%"
exit /b %ERRORLEVEL%

@rem -------------------------------------------------------------------------------
@rem Batch Script Help Part Displayer
@rem -------------------------------------------------------------------------------
@rem usage:
@rem     bshelp[.cmd] source
@rem arguments:
@rem     source:
@rem         batch script file path.

@setlocal

@set SOURCE=%~1
@if not defined SOURCE call "%~f0" "%~f0" & exit /b 1

@set PSCMD=^
Get-Content -LiteralPath '%SOURCE%' -Encoding OEM ^| ^
ForEach-Object { ^
if ($_ -match '^^\s*@?rem( ?(?^<HelpMessage^>.*))') { ^
Write-Output $Matches['HelpMessage'] ^
} ^
}
:: don't use `ps.cmd` because response speed is priority.
@powershell -NoProfile -Command "%PSCMD%"
@exit /b %ERRORLEVEL%

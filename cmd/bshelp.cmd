@rem -------------------------------------------------------------------------------
@rem Batch Script Help Part Displayer
@rem -------------------------------------------------------------------------------
@rem usage:
@rem     bshelp[.cmd] source [preamble]
@rem arguments:
@rem     source:
@rem         batch script file path.
@rem     preamble:
@rem         help row preamble. (default `rem`)

@setlocal

@set SOURCE=%~1
@if not defined SOURCE call "%~f0" "%~f0" "@rem" & exit /b 1

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

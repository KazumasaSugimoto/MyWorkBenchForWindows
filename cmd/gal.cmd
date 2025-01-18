@echo off

rem PowerShell Get-Alias

if "%~1%~3" equ "*" (
    if "%~2" neq "" (
        powershell Get-Alias -Definition %~2
        exit /b 0
    )
)
powershell Get-Alias %*

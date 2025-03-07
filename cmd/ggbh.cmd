@echo off

rem Get Git Blob Hash

:: try native command
git hash-object %* 2>nul
if not ERRORLEVEL 1 exit /b 0

:: when missing native command
ps.cmd -File "%~dpn0.ps1" %*

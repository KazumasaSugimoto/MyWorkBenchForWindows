@echo off

rem Batch Script Help Part Displayer

call ps.cmd -File "%~dpn0.ps1" %*
exit /b %ERRORLEVEL%

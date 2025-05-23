@echo off

rem Batch Script Help Part Displayer

:: don't use `ps.cmd` because response speed is priority.
powershell -NoProfile -File "%~dpn0.ps1" %*
exit /b %ERRORLEVEL%

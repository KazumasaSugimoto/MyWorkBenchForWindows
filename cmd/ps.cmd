@echo off

rem PowerShell Invoker

:TRY_MY_DEFAULT

if not defined MYDEF_PSEXE goto TRY_NEW_VERSION

where %MYDEF_PSEXE% >nul 2>&1
if ERRORLEVEL 1 goto TRY_NEW_VERSION

%MYDEF_PSEXE% %*
exit /b %ERRORLEVEL%

:TRY_NEW_VERSION

where pwsh >nul 2>&1
if ERRORLEVEL 1 goto USE_OLD_VERSION

pwsh %*
exit /b %ERRORLEVEL%

:USE_OLD_VERSION

powershell %*
exit /b %ERRORLEVEL%

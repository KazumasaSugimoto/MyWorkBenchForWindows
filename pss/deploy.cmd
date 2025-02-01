@echo off

for /f "usebackq tokens=*" %%a in (`echov.cmd --edit-self -es /es :es`) do if /i "%~1" equ "%%a" goto EDIT_SELF

echo -------------------------------------------------------------------------------
echo Deploy PowerShell Profiles
echo -------------------------------------------------------------------------------

setlocal

for /f "usebackq tokens=*" %%a in (`powershell $PROFILE.CurrentUserAllHosts`   ) do call :COPY "%%a"
for /f "usebackq tokens=*" %%a in (`pwsh -Command $PROFILE.CurrentUserAllHosts`) do call :COPY "%%a"

exit /b 0

:COPY

set SOURCE=%~dp0%~nx1
set DESTINATION=%~dp1

echo.
echo %SOURCE%
echo -^> %DESTINATION%
echo.

set ANS_YN=y
set /p ANS_YN="OK? ([Y]/n) > "
if /i "%ANS_YN%" equ "n" goto :EOF

if not exist "%DESTINATION%" mkdir "%DESTINATION%"
copy "%SOURCE%" "%DESTINATION%"
goto :EOF

:EDIT_SELF

call code.cmd "%~f0"
exit /b 0

::? -------------------------------------------------------------------------------
::? ERRORLEVEL Getter/Setter
::? -------------------------------------------------------------------------------
::? usage:
::?     errlvl[.cmd]
::?         getter mode.
::?     errlvl[.cmd] number
::?         setter mode.
::! implementation note:
::!     in the following cases, no error occurs and the value remains unchanged.
::!         `exit /b`
::!         `exit /b invalid-value`
@if "%~1" equ "" echo %ERRORLEVEL%
@exit /b %~1

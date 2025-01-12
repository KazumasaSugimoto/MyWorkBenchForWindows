:LOOP
@if "%~1" equ "" exit /b 0
@echo.%~1
@shift /1
@goto LOOP

@setlocal
:PUT_ARGS_LOOP
@set ARGV=%~1
@if not defined ARGV exit /b 0
:PUT_CHAR_LOOP
@echo.%ARGV:~0,1%
@set ARGV=%ARGV:~1%
@if defined ARGV goto PUT_CHAR_LOOP
@shift /1
@goto PUT_ARGS_LOOP

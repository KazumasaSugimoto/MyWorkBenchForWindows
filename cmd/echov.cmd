::  main uses:
::      Treat wildcard symbols ('*','?') as charcters in the `for` command.
::  example:
::      NG: for %%a in ( --help -? /? ) do if /i "%~1" equ "%%a" ...
::      OK: for /f "usebackq tokens=*" %%a in (`echov.cmd --help -? /?`) do if /i "%~1" equ "%%a" ...
:LOOP
@if "%~1" equ "" exit /b 0
@echo.%~1
@shift /1
@goto LOOP

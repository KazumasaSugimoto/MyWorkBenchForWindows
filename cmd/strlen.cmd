::? -------------------------------------------------------------------------------
::? String Length
::? -------------------------------------------------------------------------------
::? usage:
::?     strlen[.cmd] string [retvar]
::? example:
::?     strlen "abc"
::?       or
::?     strlen "abc" LEN >nul
::?     echo %LEN%

@setlocal EnableDelayedExpansion

@set STRING=%1
@if not defined STRING call bshelp.cmd "%~f0" "::?" & exit /b 1

@set LENGTH=0
@set STRING=%~1
@if not defined STRING goto PUT_RESULT

:CHECK_NEXT_CHAR

@if "!STRING:~%LENGTH%!" equ "" goto PUT_RESULT
@set /a LENGTH+=1
@goto CHECK_NEXT_CHAR

:PUT_RESULT

@echo %LENGTH%
@endlocal & if "%~2" neq "" set %~2=%LENGTH%

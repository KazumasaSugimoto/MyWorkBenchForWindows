@echo off

rem -------------------------------------------------------------------------------
rem Remove or Cleanup(Remake) Directory
rem -------------------------------------------------------------------------------
rem improves performance of removing or cleaning directory
rem that contain many files.
rem
rem usage:
rem     rmd[.cmd] target [options...]
rem target:
rem     existing folder path.
rem options:
rem     --cleanup  | -c ... remake mode.
rem     --no-pause | -n ... avoid execution confirmation.
:: PEND: verbose mode. ( --verbose | - v )

setlocal

set TARGET_PATH=
set CLEANUP_MODE=
set NOPAUSE_MODE=

:ARGS_PARSE_TRY

if "%~1" equ "" goto ARGS_PARSE_END

if defined TARGET_PATH goto OPTS_DETECT_TRY
if not exist "%~1"     goto OPTS_DETECT_TRY

:SET_TARGET_PATH

pushd "%~1"
if ERRORLEVEL 1 goto OPTS_DETECT_TRY
set TARGET_PATH=%CD%
popd
goto NEXT_ARGS

:OPTS_DETECT_TRY

for /f "usebackq tokens=*" %%a in (`echor.cmd --cleanup  -c /c :c`) do if /i "%~1" equ "%%a" ((set CLEANUP_MODE=True) & goto NEXT_ARGS)
for /f "usebackq tokens=*" %%a in (`echor.cmd --no-pause -n /n :n`) do if /i "%~1" equ "%%a" ((set NOPAUSE_MODE=True) & goto NEXT_ARGS)

echo invalid argument: `%~1` >&2

:NEXT_ARGS

shift /1
goto ARGS_PARSE_TRY

:ARGS_PARSE_END

if not defined TARGET_PATH goto SHOW_HELP

set MODE_CAPTION_FOR_CONFIRM=remove
set MODE_CAPTION_FOR_DOING=removing
if defined CLEANUP_MODE (
    set MODE_CAPTION_FOR_CONFIRM=cleanup
    set MODE_CAPTION_FOR_DOING=cleaning
)

if defined NOPAUSE_MODE goto DO_MAIN

:CONFIRM

echo.
echo %MODE_CAPTION_FOR_CONFIRM% following:
echo     %TARGET_PATH%
pause
echo.
echo really?
pause

:DO_MAIN

echo.
echo %TARGET_PATH%
echo %MODE_CAPTION_FOR_DOING% ...

pushd "%TARGET_PATH%"
:: this is the key point for improves performance.
del /s /q /f *.* >nul
:: TBD: error handling.

pushd ..
rmdir /s /q "%TARGET_PATH%"
:: TBD: error handling.
if defined CLEANUP_MODE mkdir "%TARGET_PATH%"
popd

:FINALLY

popd
exit /b 0

:SHOW_HELP

call bshelp.cmd "%~f0"
exit /b 1

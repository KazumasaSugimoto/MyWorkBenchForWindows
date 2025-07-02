::? -------------------------------------------------------------------------------
::? Find Git Objects
::? -------------------------------------------------------------------------------
::? usage:
::?     fgo[.cmd] [search-word]

@echo off
setlocal EnableDelayedExpansion

if "%~1" equ "" (set FINDSTR_ARGS=/R ".*") else (set FINDSTR_ARGS=/IL "%~1")

(set TAB=	)
set GITCMD1=git rev-list --objects --all
set GITCMD2=git cat-file --batch-check^^="%%(objecttype)|%%(objectname)|%%(objectsize)|%%(deltabase)|%%(objectsize:disk)|%%(rest)"

for /f "usebackq tokens=*" %%a in (`%GITCMD1% ^| %GITCMD2% ^| utf8-to-sjis.cmd ^| findstr %FINDSTR_ARGS%`) do (
    set RESULT=%%a
    echo !RESULT:^|=%TAB%!
)

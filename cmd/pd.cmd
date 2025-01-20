@echo off
rem pushd/popd helper
if "%~1" equ "" popd & goto :EOF
pushd "%~1"

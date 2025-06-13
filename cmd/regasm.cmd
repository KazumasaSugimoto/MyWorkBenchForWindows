@echo off

rem -------------------------------------------------------------------------------
rem .NET Framework Assembly Registration Utility (regasm.exe) Invoker
rem -------------------------------------------------------------------------------
rem usage:
rem     [ x86 | x64 ] regasm[.cmd] native-arguments...

setlocal

set COMMON_PATH=C:\Windows\Microsoft.NET\Framework
set EXE_FOLDER_PATH=

if defined REQ_VER_X86 set EXE_FOLDER_PATH=%COMMON_PATH%\v4.0.30319
if defined REQ_VER_X64 set EXE_FOLDER_PATH=%COMMON_PATH%64\v4.0.30319

if not defined EXE_FOLDER_PATH (
    call bshelp.cmd "%~f0"
    exit /b 1
)

"%EXE_FOLDER_PATH%\regasm.exe" %*

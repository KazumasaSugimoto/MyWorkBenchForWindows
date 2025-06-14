@echo off

rem -------------------------------------------------------------------------------
rem OLE/COM Object Viewer (oleview.exe) Invoker
rem -------------------------------------------------------------------------------
rem usage:
rem     [ x86 | x64 ] oleview[.cmd] native-arguments...
rem hint:
rem     If you see the following warning ...
rem         > DllRegisterServer in IVIEWERS.DLL failed
rem     Start it once with administrator privileges.   

setlocal

set COMMON_PATH=C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0
set EXE_FOLDER_PATH=

if defined REQ_VER_X86 set EXE_FOLDER_PATH=%COMMON_PATH%\x86
if defined REQ_VER_X64 set EXE_FOLDER_PATH=%COMMON_PATH%\x64

if not defined EXE_FOLDER_PATH (
    call bshelp.cmd "%~f0"
    exit /b 1
)

start "launch" "%EXE_FOLDER_PATH%\oleview.exe" %*

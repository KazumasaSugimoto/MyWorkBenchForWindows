@echo off

rem Set host window title.

if "%~1" equ ""   title %CD%  & exit /b 0
if "%~1" equ "."  title %~nx1 & exit /b 0
if "%~1" equ ".." title %~nx1 & exit /b 0

title %~1

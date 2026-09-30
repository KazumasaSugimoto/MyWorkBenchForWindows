@echo off

setlocal
set EXPORT_TARGET_REG_KEY=HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters
set OUTPUT_FILE_PATH=%~f1

echo ---------------------------------------------------------------------
echo 現在のキーボードレイアウトに関するレジストリ情報をエクスポートします
echo ---------------------------------------------------------------------
echo エクスポート対象:
echo     %EXPORT_TARGET_REG_KEY%
echo 出力先:
echo.    %OUTPUT_FILE_PATH%
echo.

if  not defined OUTPUT_FILE_PATH (
    echo 出力先ファイルパスが未指定です。>&2
    echo usage:>&2
    echo     %~nx0 "出力先ファイルパス">&2
    timeout /t 5
    exit /b 1
)

if exist "%OUTPUT_FILE_PATH%" (
    echo 出力先ファイルが既に存在します。>&2
    echo 安全対策のため上書きには対応していません。>&2
    timeout /t 5
    exit /b 1
)

pause

reg export "%EXPORT_TARGET_REG_KEY%" "%OUTPUT_FILE_PATH%"

@echo off

setlocal

::: 管理者権限がないと失敗するコマンドを実行して
::: 現在のセッションが管理者権限で開かれているか否かを確認する
openfiles >nul 2>&1
if not ERRORLEVEL 1 goto DO_MAIN

echo ---------------------------------------------------------------------
echo キーボードレイアウト変更
echo ---------------------------------------------------------------------
echo 本操作には管理者権限が必要です。
echo 続行を選択後に管理者権限での実行確認ダイアログが表示されます。
pause

set SUDO_CMD=
where sudo.cmd >nul 2>&1
if not ERRORLEVEL 1 set SUDO_CMD=call sudo.cmd
where sudo.exe >nul 2>&1
if not ERRORLEVEL 1 set SUDO_CMD=sudo.exe

if not defined SUDO_CMD (
    echo 管理者権限に昇格させるための sudo コマンドが見つかりません。>&2
    echo 手動で管理者権限で開いたコマンドプロンプトから再実行してください。>&2
    timeout /t 5
    exit /b 1
)

%SUDO_CMD% "%~f0"
set EXITCODE=%ERRORLEVEL%
color
exit /b %EXITCODE%

:DO_MAIN

pushd "%~dp0"

color 5F
echo ---------------------------------------------------------------------
echo キーボードレイアウト変更 ※管理者権限で実行中※
echo ---------------------------------------------------------------------
echo レジストリの値を操作してキーボードレイアウトを変更します。
echo *** ここで行なう変更は再起動後に有効化されます ***
echo.
echo 選択肢:
echo     1. Default
echo     2. Mac(US)
echo     3. ThinkPad(US)
echo     9. Quit
echo.

:SELECT_MENU

set MENU_ID=0
set /p MENU_ID="? > "
set /a MENU_ID+=0

if %MENU_ID% equ 1 goto RESET_TO_DEFAULT
if %MENU_ID% equ 2 goto CHANGE_TO_MAC_US
if %MENU_ID% equ 3 goto CHANGE_TO_THINKPAD_US
if %MENU_ID% equ 9 exit /b 0
goto SELECT_MENU

:INITIALIZE_SCANCODE_MAP

echo.
echo ### Scancode Map を 初期化(削除)します。(既に削除済みの場合はエラーになります)
echo.
pause
echo.
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /f

goto :EOF

:REBOOT_PC

color E4
echo.
echo ### コンピュータ を 再起動します。
echo.
pause
color 4E
echo.
echo 30秒後に再起動を開始します。直ちに再起動したい場合は何かキーを押してください。
echo 中断したい場合はこの画面を閉じてください。
echo.
timeout /t 30

shutdown -r -t 0
exit /b 0

:RESET_TO_DEFAULT

echo ---------------------------------------------------------------------
echo *** 標準 (日本語配列) ***
echo ---------------------------------------------------------------------

call :INITIALIZE_SCANCODE_MAP

echo.
echo ### ハードウェアキーボードレイアウト を 日本語キーボード(106/109キー) に変更します。
echo.
pause
echo.
reg import "i8042prt-parameters-subset-of-ja.reg"

goto REBOOT_PC

:CHANGE_TO_MAC_US

echo ---------------------------------------------------------------------
echo *** Mac (US配列) ***
echo ---------------------------------------------------------------------

call :INITIALIZE_SCANCODE_MAP

echo.
echo ### ハードウェアキーボードレイアウト を 英語キーボード(101/102キー) に変更します。
echo.
pause
echo.
reg import "i8042prt-parameters-subset-of-us.reg"

echo.
echo ### Scancode Map を Mac(US)キーボード を前提に設定します。
echo.
pause
echo.
reg import "scancodemap-for-apple-us.reg"

goto REBOOT_PC

:CHANGE_TO_THINKPAD_US

echo ---------------------------------------------------------------------
echo *** ThinkPad (US配列) ***
echo ---------------------------------------------------------------------

call :INITIALIZE_SCANCODE_MAP

echo.
echo ### ハードウェアキーボードレイアウト を 英語キーボード(101/102キー) に変更します。
echo.
pause
echo.
reg import "i8042prt-parameters-subset-of-us.reg"

echo.
echo ### Scancode Map を ThinkPad(US)キーボード を前提に設定します。
echo.
pause
echo.
reg import "scancodemap-for-thinkpad-us.reg"

goto REBOOT_PC

<#
.SYNOPSIS
    KeyRemapper.cs を読み込み、PowerShell 5.x からグローバルキーボードリマッパーを起動する。

.DESCRIPTION
    KeyRemapper.cs のソースをそのまま Add-Type でコンパイルし、KeyRemapper インスタンスの
    Hook() を呼んで Application.Run() でメッセージループを回す。リマップのロジック（右 Ctrl
    でのナビゲーション等）は KeyRemapper.cs 側にある。

    フックはグローバル。起動するとプロセス終了までシステム全体のキーボード動作が変わる。
    停止するにはこのコンソールウィンドウを閉じる（明示的な終了キーはない）。

.PARAMETER KeyLog
    詳細なキーログをコンソールに色分け表示する（元 C# 版の /v 引数に相当）。

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\KeyRemapper.ps1
    powershell -ExecutionPolicy Bypass -File .\KeyRemapper.ps1 -KeyLog

.NOTES
    - 低レベルフック（WH_KEYBOARD_LL）のためメッセージループが必須。powershell.exe は既定で STA。
    - KeyRemapper.cs は 64bit プロセス（powershell.exe）向けに調整済み。INPUT 構造体は
      x64 レイアウト（dwExtraInfo が IntPtr、共用体オフセット 8）で、SendInput が正しく動く。
      32bit の powershell.exe では動かないので注意。
    - KeyRemapper.cs には未使用フィールド（prevKey 等、vim モード用の足場）があるため、
      既定の「警告をエラー扱い」ではコンパイルに失敗する。TreatWarningsAsErrors = $false で回避。
    - using System.Diagnostics.Eventing.Reader; のため System.Core.dll の参照が必要。
#>
[CmdletBinding()]
param(
    [switch]$KeyLog
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([IntPtr]::Size -ne 8) {
    throw '64bit の PowerShell で実行すること（KeyRemapper.cs は x64 レイアウト前提）。'
}

# KeyRemapper.cs をこのスクリプトと同じディレクトリから読み込む
$csPath = Join-Path -Path $PSScriptRoot -ChildPath 'KeyRemapper.cs'
if (-not (Test-Path -LiteralPath $csPath)) {
    throw "KeyRemapper.cs が見つからない: $csPath"
}

$source = Get-Content -LiteralPath $csPath -Raw

# コンパイル（型は一度だけ読み込まれる）
if (-not ('MyKeyRemapper.KeyRemapper' -as [type])) {
    $cp = New-Object System.CodeDom.Compiler.CompilerParameters
    $cp.ReferencedAssemblies.Add('System.dll')                 | Out-Null
    $cp.ReferencedAssemblies.Add('System.Core.dll')            | Out-Null
    $cp.ReferencedAssemblies.Add('System.Windows.Forms.dll')   | Out-Null
    $cp.ReferencedAssemblies.Add('System.Drawing.dll')         | Out-Null
    $cp.TreatWarningsAsErrors = $false
    $cp.GenerateInMemory = $true
    Add-Type -TypeDefinition $source -CompilerParameters $cp
}

$defFC = [Console]::ForegroundColor
$defBC = [Console]::BackgroundColor

[Console]::ForegroundColor = [ConsoleColor]::White
Write-Host 'Key Remapper Start...'

$keyRemapper = New-Object MyKeyRemapper.KeyRemapper
try {
    $keyRemapper.Hook($KeyLog.IsPresent)          # /v 相当
    [System.Windows.Forms.Application]::Run()     # System.Windows.Forms のメッセージループ
    $keyRemapper.HookEnd()
}
catch {
    [Console]::ForegroundColor = [ConsoleColor]::Magenta
    [Console]::Error.WriteLine($_.Exception.ToString())
}
finally {
    # 例外や中断でループを抜けてもフックを必ず解除する
    try { $keyRemapper.HookEnd() } catch { }
    [Console]::ForegroundColor = $defFC
    [Console]::BackgroundColor = $defBC
    Write-Host 'Key Remapper End.'
}

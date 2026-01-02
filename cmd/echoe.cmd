::? -----------------------------------------------------------
::? Escaped Echo
::? -----------------------------------------------------------
::? sypnosis:
::?     Uses escape sequence codes to decorate characters in
::?     Command Prompt's standard output.
::? usage:
::?     echoe[.cmd] "message..."
::? message:
::?     ** Must be enclosed in double quotes! **
::? example:
::?     echoe "${yellow}${bold}${blink}!!! ERROR !!!${reset}"
::? note:
::?     Since PowerShell is launched each time a single line of
::?     output is generated, processing speed will be relatively slow.
::?     For applying the same decoration across multiple lines,
::?     it may be better to only send the escape sequence codes
::?     at the beginning and end using this command, while sending
::?     the rest of the message body via a regular echo command.

@if "%~1" equ "" (
    call bshelp.cmd "%~f0"
    exit /b 1
)

@setlocal

@set PSCMD=^
[char]$esc = 27; ^
$reset = """$esc[0m"""; ^
$bold = """$esc[1m"""; ^
$light = """$esc[1m"""; ^
$normal = """$esc[2m"""; ^
$dark = """$esc[2m"""; ^
$itaric = """$esc[3m"""; ^
$ul = """$esc[4m"""; ^
$blink = """$esc[5m"""; ^
$blink2 = """$esc[6m"""; ^
$reverse = """$esc[7m"""; ^
$default = """$esc[49m"""; ^
$black = """$esc[30m"""; ^
$red = """$esc[31m"""; ^
$green = """$esc[32m"""; ^
$yellow = """$esc[33m"""; ^
$blue = """$esc[34m"""; ^
$magenta = """$esc[35m"""; ^
$cyan = """$esc[36m"""; ^
$white = """$esc[37m"""; ^
Write-Output ("""%~1""")

@powershell -NoProfile -Command "%PSCMD%"

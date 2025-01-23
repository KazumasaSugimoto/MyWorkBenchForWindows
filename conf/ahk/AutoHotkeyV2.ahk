;###############################################################
;
;   AutoHotKey V2 Setting.
;
;   ^ is Ctrl
;   ! is Alt
;   + is Shift
;   # is Win
;
;   memo. If ( WinActive("ahk_exe idea64.exe") )
;
;###############################################################

#UseHook

;===============================================================
;   Common Setting
;===============================================================

;-----------------------
;   a A

;-----------------------
;   b B

   <^<!<#b:: switchOrLaunchApplication("Web Browser", "chrome.exe")

;-----------------------
;   c C

;-----------------------
;   d D

;-----------------------
;   e E

;-----------------------
;   f F

;-----------------------
;   g G

   <^<!<#g:: switchOrLaunchApplication("Shell", "mintty.exe", "gb.cmd")

;-----------------------
;   h H

       >^h:: Send   "{Left}"
     <^>^h:: Send  "^{Left}"
     <!>^h:: Send  "!{Left}"
     <#>^h:: Send   "{Home}"
     <+>^h:: Send  "+{Left}"
   <+<^>^h:: Send "+^{Left}"
   <+<!>^h:: Send "+!{Left}"
   <+<#>^h:: Send  "+{Home}"

;-----------------------
;   i I

       >^i:: Send  "{F2}"

;-----------------------
;   j J

       >^j:: Send   "{Down}"
     <^>^j:: Send  "^{Down}"
     <!>^j:: Send  "!{Down}"
     <#>^j:: Send   "{PgDn}"
     <+>^j:: Send  "+{Down}"
   <+<^>^j:: Send "+^{Down}"
   <+<!>^j:: Send "+!{Down}"
   <+<#>^j:: Send  "+{PgDn}"

   <^<!<#j:: switchOrLaunchApplication("IDE", "eclipse.exe", "eclipse.cmd")

;-----------------------
;   k K

       >^k:: Send   "{Up}"
     <^>^k:: Send  "^{Up}"
     <!>^k:: Send  "!{Up}"
     <#>^k:: Send   "{PgUp}"
     <+>^k:: Send  "+{Up}"
   <+<^>^k:: Send "+^{Up}"
   <+<!>^k:: Send "+!{Up}"
   <+<#>^k:: Send  "+{PgUp}"

;  <^<!<#k:: switchOrLaunchApplication("Code Editor", "code.exe", "code.cmd")

;-----------------------
;   l L

       >^l:: Send   "{Right}"
     <^>^l:: Send  "^{Right}"
     <!>^l:: Send  "!{Right}"
     <#>^l:: Send   "{End}"
     <+>^l:: Send  "+{Right}"
   <+<^>^l:: Send "+^{Right}"
   <+<!>^l:: Send "+!{Right}"
   <+<#>^l:: Send  "+{End}"

   <^<!<#l:: SwitchExplorer ;; TODO

;-----------------------
;   m M

       >^m:: Send "{AppsKey}" ;; TODO
;  <^<!<#m:: ToggleMode
   <^<!<#m:: switchOrLaunchApplication("Mailer", "outlook.exe")

;-----------------------
;   n N

   <^<!<#n:: switchOrLaunchApplication("Text Editor", "notepad.exe")

;-----------------------
;   o O

   <^<!<#o:: switchOrLaunchApplication("Spread Sheet", "excel.exe")

;-----------------------
;   p P

       >^p:: Send "^v"

;-----------------------
;   q Q

       >^q:: closeWindow()

;-----------------------
;   r R

;-----------------------
;   s S

;-----------------------
;   t T

;-----------------------
;   u U

;      <^u:: Send "^z"

;-----------------------
;   v V

;-----------------------
;   w W

       >^w:: closeTabInWindow()

;-----------------------
;   x X

;-----------------------
;   y Y

       >^y:: Send "^c"

;-----------------------
;   z Z

;-----------------------
;   Escape

;-----------------------
;   F1

;-----------------------
;   F2

;-----------------------
;   F3

;-----------------------
;   F4

;-----------------------
;   F5

;-----------------------
;   F6

;-----------------------
;   F7

;-----------------------
;   F8

;-----------------------
;   F9

;-----------------------
;   F10

;-----------------------
;   F11

;-----------------------
;   F12

;-----------------------
;   Delete

;-----------------------
;   ` ~

;-----------------------
;   1 !

;-----------------------
;   2 @

;-----------------------
;   3 #

;-----------------------
;   4 $

;-----------------------
;   5 %

;-----------------------
;   6 ^

;-----------------------
;   7 &

;-----------------------
;   8 *

;-----------------------
;   9 (

;-----------------------
;   0 )

;-----------------------
;   - _

;-----------------------
;   = +

;-----------------------
;   BackSpace

;     <^BS:: Send  "{Del}"
      >^BS:: Send  "{Del}"
    <+>^BS:: Send "+{Del}"

;-----------------------
;   Tab

     >^TAB:: Send  "!{TAB}"  ;; TODO Alt-Down state keep.
;  <+>^TAB:: Send "+!{TAB}"  ;; TODO Alt-Down state keep.

;-----------------------
;   [ {

       <^[:: Send  "{ESC}"
       >^[:: Send  "{ESC}"
;      >^[:: Send  "{Home}"
;    <+>^[:: Send "+{Home}"
;  <^<!<#[:: SetVimNormalMode
       <#[:: moveHistoryStack("back")   ;; TODO
     <+<#[:: changeTabInWindow("left")  ;; TODO
   <+<^<#[:: changeWindowOfSameApplication("back")  ;; TODO

;-----------------------
;   ] }

;      >^]:: Send  "{End}"
;    <+>^]:: Send "+{End}"
;  <^<!<#]:: SetDefaultMode
       <#]:: moveHistoryStack("forward")    ;; TODO
     <+<#]:: changeTabInWindow("right") ;; TODO
   <+<^<#]:: changeWindowOfSameApplication("next")  ;; TODO

;-----------------------
;   \ |

;      >^\:: Send "{Esc}"
   <^<!<#\:: switchOrLaunchApplication("Compare", "BCompare.exe", "bc4.cmd")

;-----------------------
;   ; :

    <+>^`;:: Send "#r" ;; TODO
      >^`;:: FocusApplicationAddressBar

   <^<!<#;:: switchOrLaunchApplication("Code Editor", "code.exe", "code.cmd")

;-----------------------
;   ' "

       >^':: Send "#r"

;-----------------------
;   Enter

;<^<!<#Enter:: ToggleMode

;-----------------------
;   , <

       >^,:: Send "+{Tab}"

;-----------------------
;   . >

       >^.:: Send  "{Tab}"
;  <^<!<#.:: switchOrLaunchApplication("Command Shell", "cmd.exe", "%COMSPEC% /k cd ""%USERPROFILE%""")
;  <^<!<#.:: switchOrLaunchApplication("Command Shell", "cmd.exe", "cmd.exe /k cd ""%USERPROFILE%""")
   <^<!<#.:: switchOrLaunchApplication("Command Shell", "WindowsTerminal.exe", "wt.exe")
;      <^.:: Send  "{Tab}"   ;; HINT Eclipse(Next Annotation)
;    <!<^.:: Send "!{Tab}"

;-----------------------
;   / ?

;<^<!<#/:: QueryMode

;-----------------------
;   Space

 >^Space:: Send "{BS}"
;<^Space:: Send "{BS}"
; HINT
; +Space @Excel : row select
; ^Space @Excel : col select
 <^<!<#Space:: MouseClick "Left"

;===============================================================
;  
;===============================================================

moveHistoryStack(moveDirection)
{
    ;; Alt + [Left|Right]
    ;;   Chrome
    ;;   VSCode
    
    If (moveDirection = "back")
    {
        Send "!{Left}"
    }
    Else If (moveDirection = "forward")
    {
        Send "!{Right}"
    }
    Else
    {
        ; Button : OK(0)
        ; Icon   : x(16)
        MsgBox "Undefined Argument`n" moveDirection, "AutoHotKey Alert", "IconX OK"
    }
    return
}

changeTabInWindow(changeDirection)
{
    ;; Control [+ Shift] + Tab
    ;;   Chrome
    ;; Control + [PageUp|PageDown]
    ;;   Excel
    ;;   VSCode
    ;;   Eclipse

    If (changeDirection = "left")
    {
        If WinActive("ahk_exe excel.exe")
            Send "^{PgUp}"
        Else If WinActive("ahk_exe code.exe")
            Send "^{PgUp}"
        Else If WinActive("ahk_exe eclipse.exe")
            Send "^{PgUp}"
        Else
            Send "+^{Tab}"
    }
    Else If (changeDirection = "right")
    {
        If WinActive("ahk_exe excel.exe")
            Send "^{PgDn}"
        Else If WinActive("ahk_exe code.exe")
            Send "^{PgDn}"
        Else If WinActive("ahk_exe eclipse.exe")
            Send "^{PgDn}"
        Else
            Send "^{Tab}"
    }
    Else
    {
        ; Button : OK(0)
        ; Icon   : x(16)
        MsgBox "Undefined Argument`n" changeDirection, "AutoHotKey Alert", "IconX OK"
    }
    return
}

closeTabInWindow()
{
    Send "^w"    ;; Native
}

changeWindowOfSameApplication(changeDirection)
{
    If (changeDirection = "back")
    {
        Send "+^#["  ;; TODO
    }
    Else If (changeDirection = "next")
    {
        Send "+^#]"  ;; TODO
    }
    Else
    {
        ; Button : OK(0)
        ; Icon   : x(16)
        MsgBox "Undefined Argument`n" changeDirection, "AutoHotKey Alert", "IconX OK"
    }
    return
}

closeWindow()
{
    windowTitle := WinGetTitle("A") 
;;  WinGet, pid, PID, A ;; when using 'Process, Close'
    ; Button  : Yes/No(4)
    ; Icon    : !(48)
    ; Default : No<2nd>(256)
    YNAns := MsgBox("Current window is`n" windowTitle "`n`nClose this windows!`nAre you sure?", "AutoHotKey Confirmation", "Icon! YesNo Default2")
    If YNAns = "Yes"
    {
    ;;  Send "!{F4}" ;; disabled for cmd.exe
        WinClose windowTitle
        ;; HINT
        ;;   other methods...
        ;;  WinKill, %windowTitle%
        ;;  Process, Close, %pid%
    }
    return
}

;===============================================================
;   SWITCH(or LAUNCH) APPLICATION
;===============================================================

switchOrLaunchApplication(appName, procName, cmdLine:="")
{
    ; TODO
    ;   ifExistAction
    ;     change active
    ;   ifAlreadyActiveAction
    ;     close (toggle)
    ;     change activate to same application other window

    If (cmdLine = "")
        cmdLine := procName

;;  Process, Exist, %procName%
;;  If (ErrorLevel <> 0)
    If WinExist("ahk_exe " procName)
    {
    ;;  WinActivate, ahk_pid %ErrorLevel%
        WinActivate
    }
    Else
    {
        TrayTip "Accepted request!`nStart " appName " (" procName ")", "AutoHotKey Notice", "IconI"
        Run cmdLine
    }
    return
}

SwitchExplorer()
{
    If WinExist("ahk_class CabinetWClass")
    {
        WinActivate
    }
    Else
    {
        Run "explorer.exe"
    }
    return
}

;===============================================================
;   APPLICATION FUNCTIONS
;===============================================================

FocusApplicationAddressBar()
{
    If WinActive("ahk_exe explorer.exe")
    {
        Send "!d"
    }
    Else If WinActive("ahk_exe iexplorer.exe")
    {
        Send "!d"
    }
    Else If WinActive("ahk_exe chrome.exe")
    {
        Send "!d"
    }
    Else If WinActive("ahk_exe code.exe")
    {
        Send "+^p"
    }
    Else If WinActive("ahk_exe excel.exe")
    {
        Send "{F2}"
    }
    Else If WinActive("ahk_exe bc2.exe")
    {
        Send "{F2}"
    }
    Else
    {
        Send "#r"
    }
    return
}

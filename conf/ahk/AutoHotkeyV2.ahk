;###############################################################
;
;   AutoHotKey V2 Setting.
;
;   ^ is Ctrl
;   ! is Alt
;   + is Shift
;   # is Win
;
;   memo. if ( WinActive("ahk_exe idea64.exe") )
;
;###############################################################

SetStoreCapsLockMode 0

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

   <^<!<#l:: switchExplorer ;; TODO

;-----------------------
;   m M

       >^m:: Send "{AppsKey}" ;; TODO
;  <^<!<#m:: toggleMode
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
;  <^<!<#[:: setVimNormalMode
       <#[:: moveHistoryStack("back")   ;; TODO
     <+<#[:: changeTabInWindow("left")  ;; TODO
   <+<^<#[:: changeWindowOfSameApplication("back")  ;; TODO

;-----------------------
;   ] }

;      >^]:: Send  "{End}"
;    <+>^]:: Send "+{End}"
;  <^<!<#]:: setDefaultMode
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
      >^`;:: focusApplicationAddressBar

   <^<!<#;:: switchOrLaunchApplication("Code Editor", "code.exe", "code.cmd")

;-----------------------
;   ' "

       >^':: Send "#r"

;-----------------------
;   Enter

;<^<!<#Enter:: toggleMode

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

;<^<!<#/:: queryMode

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
    
    if (moveDirection = "back")
    {
        Send "!{Left}"
    }
    else if (moveDirection = "forward")
    {
        Send "!{Right}"
    }
    else
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

    if (changeDirection = "left")
    {
        if WinActive("ahk_exe excel.exe")
            Send "^{PgUp}"
        else if WinActive("ahk_exe code.exe")
            Send "^{PgUp}"
        else if WinActive("ahk_exe eclipse.exe")
            Send "^{PgUp}"
        else
            Send "+^{Tab}"
    }
    else if (changeDirection = "right")
    {
        if WinActive("ahk_exe excel.exe")
            Send "^{PgDn}"
        else if WinActive("ahk_exe code.exe")
            Send "^{PgDn}"
        else if WinActive("ahk_exe eclipse.exe")
            Send "^{PgDn}"
        else
            Send "^{Tab}"
    }
    else
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
    if (changeDirection = "back")
    {
        Send "+^#["  ;; TODO
    }
    else if (changeDirection = "next")
    {
        Send "+^#]"  ;; TODO
    }
    else
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
    AnsYN := MsgBox("Current window is`n" windowTitle "`n`nClose this windows!`nAre you sure?", "AutoHotKey Confirmation", "Icon! YesNo Default2")
    if AnsYN = "Yes"
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

    if (cmdLine = "")
        cmdLine := procName

;;  Process, Exist, %procName%
;;  if (ErrorLevel <> 0)
    if WinExist("ahk_exe " procName)
    {
    ;;  WinActivate, ahk_pid %ErrorLevel%
        WinActivate
    }
    else
    {
        TrayTip "Accepted request!`nStart " appName " (" procName ")", "AutoHotKey Notice", "IconI"
        Run cmdLine
    }
    return
}

switchExplorer()
{
    if WinExist("ahk_class CabinetWClass")
    {
        WinActivate
    }
    else
    {
        Run "explorer.exe"
    }
    return
}

;===============================================================
;   APPLICATION FUNCTIONS
;===============================================================

focusApplicationAddressBar()
{
    if WinActive("ahk_exe explorer.exe")
    {
        Send "!d"
    }
    else if WinActive("ahk_exe iexplorer.exe")
    {
        Send "!d"
    }
    else if WinActive("ahk_exe chrome.exe")
    {
        Send "!d"
    }
    else if WinActive("ahk_exe code.exe")
    {
        Send "+^p"
    }
    else if WinActive("ahk_exe excel.exe")
    {
        Send "{F2}"
    }
    else if WinActive("ahk_exe bc2.exe")
    {
        Send "{F2}"
    }
    else
    {
        Send "#r"
    }
    return
}

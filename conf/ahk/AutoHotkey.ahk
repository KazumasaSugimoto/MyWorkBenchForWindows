;###############################################################
;
;   AutoHotKey Setting.
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

global DEFAULT_MODE := 0
global VIM_NORMAL_MODE := 1
global VIM_VISUAL_MODE := 2
global VIM_INPUT_MODE := 3

global mode := DEFAULT_MODE

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

       >^h:: Send,   {Left}
     <^>^h:: Send,  ^{Left}
     <!>^h:: Send,  !{Left}
     <#>^h:: Send,   {Home}
     <+>^h:: Send,  +{Left}
   <+<^>^h:: Send, +^{Left}
   <+<!>^h:: Send, +!{Left}
   <+<#>^h:: Send,  +{Home}

;-----------------------
;   i I

       >^i:: Send,  {F2}

;-----------------------
;   j J

       >^j:: Send,   {Down}
     <^>^j:: Send,  ^{Down}
     <!>^j:: Send,  !{Down}
     <#>^j:: Send,   {PgDn}
     <+>^j:: Send,  +{Down}
   <+<^>^j:: Send, +^{Down}
   <+<!>^j:: Send, +!{Down}
   <+<#>^j:: Send,  +{PgDn}

   <^<!<#j:: switchOrLaunchApplication("IDE", "eclipse.exe", "eclipse.cmd")

;-----------------------
;   k K

       >^k:: Send,   {Up}
     <^>^k:: Send,  ^{Up}
     <!>^k:: Send,  !{Up}
     <#>^k:: Send,   {PgUp}
     <+>^k:: Send,  +{Up}
   <+<^>^k:: Send, +^{Up}
   <+<!>^k:: Send, +!{Up}
   <+<#>^k:: Send,  +{PgUp}

;  <^<!<#k:: switchOrLaunchApplication("Code Editor", "code.exe", "code.cmd")

;-----------------------
;   l L

       >^l:: Send,   {Right}
     <^>^l:: Send,  ^{Right}
     <!>^l:: Send,  !{Right}
     <#>^l:: Send,   {End}
     <+>^l:: Send,  +{Right}
   <+<^>^l:: Send, +^{Right}
   <+<!>^l:: Send, +!{Right}
   <+<#>^l:: Send,  +{End}

   <^<!<#l:: Gosub, SWITCH_EXPLORER ;; TODO

;-----------------------
;   m M

       >^m:: Send, {AppsKey} ;; TODO
;  <^<!<#m:: Gosub, TOGGLE_MODE
   <^<!<#m:: switchOrLaunchApplication("Mailer", "outlook.exe")

;-----------------------
;   n N

   <^<!<#n:: switchOrLaunchApplication("Text Editor", "notepad.exe")

;-----------------------
;   o O

   <^<!<#o:: switchOrLaunchApplication("Spread Sheet", "excel.exe")

;-----------------------
;   p P

       >^p:: Send, ^v

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

;      <^u:: Send, ^z

;-----------------------
;   v V

;-----------------------
;   w W

       >^w:: closeTabInWindow()

;-----------------------
;   x X

;-----------------------
;   y Y

       >^y:: Send, ^c

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

;     <^BS:: Send,  {Del}
      >^BS:: Send,  {Del}
    <+>^BS:: Send, +{Del}

;-----------------------
;   Tab

     >^TAB:: Send,  !{TAB}  ;; TODO Alt-Down state keep.
;  <+>^TAB:: Send, +!{TAB}  ;; TODO Alt-Down state keep.

;-----------------------
;   [ {

       <^[:: Send,  {ESC}
       >^[:: Send,  {ESC}
;      >^[:: Send,  {Home}
;    <+>^[:: Send, +{Home}
   <^<!<#[:: Gosub, SET_VIM_NORMAL_MODE
       <#[:: moveHistoryStack("back")   ;; TODO
     <+<#[:: changeTabInWindow("left")  ;; TODO
   <+<^<#[:: changeWindowOfSameApplication("back")  ;; TODO

;-----------------------
;   ] }

;      >^]:: Send,  {End}
;    <+>^]:: Send, +{End}
   <^<!<#]:: Gosub, SET_DEFAULT_MODE
       <#]:: moveHistoryStack("forward")    ;; TODO
     <+<#]:: changeTabInWindow("right") ;; TODO
   <+<^<#]:: changeWindowOfSameApplication("next")  ;; TODO

;-----------------------
;   \ |

;      >^\:: Send, {Esc}

;-----------------------
;   ; :

    <+>^`;:: Send, #r ;; TODO
      >^`;:: Gosub, FOCUS_APPLICATION_ADDRESS_BAR

   <^<!<#;:: switchOrLaunchApplication("Code Editor", "code.exe", "code.cmd")

;-----------------------
;   ' "

       >^':: Send, #r

;-----------------------
;   Return(Enter)

 <^<!<#Return:: Gosub, TOGGLE_MODE

;-----------------------
;   , <

       >^,:: Send, +{Tab}

;-----------------------
;   . >

       >^.:: Send,  {Tab}
;  <^<!<#.:: switchOrLaunchApplication("Command Shell", "cmd.exe", "%COMSPEC% /k cd ""%USERPROFILE%""")
   <^<!<#.:: switchOrLaunchApplication("Command Shell", "cmd.exe", "cmd.exe /k cd ""%USERPROFILE%""")
;      <^.:: Send,  {Tab}   ;; HINT Eclipse(Next Annotation)
;    <!<^.:: Send, !{Tab}

;-----------------------
;   / ?

 <^<!<#/:: Gosub, QUERY_MODE

;-----------------------
;   Space

 >^Space:: Send, {BS}
;<^Space:: Send, {BS}
; HINT
; +Space @Excel : row select
; ^Space @Excel : col select
 <^<!<#Space:: MouseClick, LEFT

;===============================================================
;  
;===============================================================

QUERY_MODE:
    If (mode = DEFAULT_MODE)
    {
        msg := "Default (OS Normal) Mode"
    }
    Else If (mode = VIM_NORMAL_MODE)
    {
        msg := "Vim Normal Mode"
    }
    Else If (mode = VIM_VISUAL_MODE)
    {
        msg := "Vim Visual Mode"
    }
    Else If (mode = VIM_EDIT_MODE)
    {
        msg := "Vim Input Mode"
    }
    Else
    {
        msg := "Unknown Mode"
    }
    MsgBox, 0,"AutoHotKey Mode",%msg%,0.5
    Return

SET_DEFAULT_MODE:
    mode := DEFAULT_MODE
    Return

SET_VIM_NORMAL_MODE:
    mode := VIM_NORMAL_MODE
    Return

TOGGLE_MODE:
    If (mode = DEFAULT_MODE)
    {
        mode := VIM_NORMAL_MODE
    }
    Else
    {
        mode := DEFAULT_MODE
    }
    Gosub, QUERY_MODE
    Return

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
        Send, !{Left}
    }
    Else If (moveDirection = "forward")
    {
        Send, !{Right}
    }
    Else
    {
        ; Button : OK(0)
        ; Icon   : x(16)
        MsgBox, 16, AutoHotKey Alert, Undefined Argument`n%moveDirection%, 5
    }
    Return
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
        IfWinActive, ahk_exe excel.exe
            Send, ^{PgUp}
        Else IfWinActive, ahk_exe code.exe
            Send, ^{PgUp}
        Else IfWinActive, ahk_exe eclipse.exe
            Send, ^{PgUp}
        Else
            Send, +^{Tab}
    }
    Else If (changeDirection = "right")
    {
        IfWinActive, ahk_exe excel.exe
            Send, ^{PgDn}
        Else IfWinActive, ahk_exe code.exe
            Send, ^{PgDn}
        Else IfWinActive, ahk_exe eclipse.exe
            Send, ^{PgDn}
        Else
            Send, ^{Tab}
    }
    Else
    {
        ; Button : OK(0)
        ; Icon   : x(16)
        MsgBox, 16, AutoHotKey Alert, Undefined Argument`n%changeDirection%, 5
    }
    Return
}

closeTabInWindow()
{
    Send, ^w    ;; Native
}

changeWindowOfSameApplication(changeDirection)
{
    If (changeDirection = "back")
    {
        Send, +^#[  ;; TODO
    }
    Else If (changeDirection = "next")
    {
        Send, +^#]  ;; TODO
    }
    Else
    {
        ; Button : OK(0)
        ; Icon   : x(16)
        MsgBox, 16, AutoHotKey Alert, Undefined Argument`n%changeDirection%, 5
    }
    Return
}

closeWindow()
{
    WinGetActiveTitle, windowTitle
;;  WinGet, pid, PID, A ;; when using 'Process, Close'
    ; Button  : Yes/No(4)
    ; Icon    : !(48)
    ; Default : No<2nd>(256)
    MsgBox, 308, AutoHotKey Confirmation, Current window is`n%windowTitle%`n`nClose this windows!`nAre you sure?, 5
    IfMsgBox, Yes
    {
    ;;  Send, !{F4} ;; disabled for cmd.exe
        WinClose, %windowTitle%
        ;; HINT
        ;;   other methods...
        ;;  WinKill, %windowTitle%
        ;;  Process, Close, %pid%
    }
    Return
}

;===============================================================
;   SWITCH(or LAUNCH) APPLICATION
;===============================================================

switchOrLaunchApplication(appName, procName, cmdLine="")
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
    IfWinExist, ahk_exe %procName%
    {
    ;;  WinActivate, ahk_pid %ErrorLevel%
        WinActivate
    }
    Else
    {
        TrayTip, AutoHotKey Notice, Accepted request!`nStart %appName% (%procName%), , 1
        Run, %cmdLine%
    }
    Return
}

SWITCH_EXPLORER:
    IfWinExist, ahk_class CabinetWClass
    {
        WinActivate
    }
    Else
    {
        Run, explorer.exe
    }
    Return

;===============================================================
;   APPLICATION FUNCTIONS
;===============================================================

FOCUS_APPLICATION_ADDRESS_BAR:
    IfWinActive, ahk_exe explorer.exe
    {
        Send, !d
    }
    Else IfWinActive, ahk_exe iexplorer.exe
    {
        Send, !d
    }
    Else IfWinActive, ahk_exe chrome.exe
    {
        Send, !d
    }
    Else IfWinActive, ahk_exe code.exe
    {
        Send, +^p
    }
    Else IfWinActive, ahk_exe excel.exe
    {
        Send, {F2}
    }
    Else IfWinActive, ahk_exe bc2.exe
    {
        Send, {F2}
    }
    Else
    {
        Send, #r
    }
    Return

;===============================================================
;   VIM NORMAL MODE
;===============================================================

#If (mode = VIM_NORMAL_MODE)

a::
    Send, {Right}
    mode := VIM_INPUT_MODE
    Return
+a::
    Send, {End}
    mode := VIM_INPUT_MODE
    Return
b::
    Send, ^{Left}
    Return
c::
    Gosub, QUERY_MODE
    Return
d::
    Gosub, QUERY_MODE
    Return
e::
    Send, ^{Right}
    Send, {Left}
    Return
f::
    Gosub, QUERY_MODE
    Return
g::
    Gosub, QUERY_MODE
    Return
h::
    Send, {Left}
    Return
i::
    mode := VIM_INPUT_MODE
    Return
+i::
    Send, {Home}
    mode := VIM_INPUT_MODE
    Return
j::
    MouseClick, WheelDown, , ,1, 0, D, R ;; Scroll-Down ;; TEST
;;  Send, {Down}
    Return
+j::
    Send, {End}
    Send, {Del}
    Return
k::
    MouseClick, WheelUp, , ,1, 0, D, R ;; Scroll-Up ;; TEST
;;  Send, {Up}
    Return
l::
    Send, {Right}
    Return
m::
    Gosub, QUERY_MODE
    Return
n::
    Gosub, QUERY_MODE
    Return
o::
    Send, {End}
    Send, {Return}
    mode := VIM_INPUT_MODE
    Return
+o::
    Send, {Home}
    Send, {Return}
    Send, {Up}
    mode := VIM_INPUT_MODE
    Return
p::
    Send, ^v
    Return
q::
    Gosub, QUERY_MODE
    Return
r::
    Gosub, QUERY_MODE
    Return
s::
    Gosub, QUERY_MODE
    Return
t::
    Gosub, QUERY_MODE
    Return
u::
    Send, ^z
    Return
v::
    mode := VIM_VISUAL_MODE
    Return
w::
    Send, ^{Right}
    Return
x::
    Send, {Del}
    Return
y::
    Send, ^c
    Return
z::
    Gosub, QUERY_MODE
    Return
1::
    Gosub, QUERY_MODE
    Return
2::
    Gosub, QUERY_MODE
    Return
3::
    Gosub, QUERY_MODE
    Return
4::
    Gosub, QUERY_MODE
    Return
5::
    Gosub, QUERY_MODE
    Return
6::
    Gosub, QUERY_MODE
    Return
7::
    Gosub, QUERY_MODE
    Return
8::
    Gosub, QUERY_MODE
    Return
9::
    Gosub, QUERY_MODE
    Return
0::
    Send, {Home}
    Return

^::
    Send, {Home}
    Return
$::
    Send, {End}
    Return

#If

;===============================================================
;   VIM VISUAL MODE
;===============================================================

#If (mode = VIM_VISUAL_MODE)

Esc::
<^[::
    Send, {Esc}
    mode := VIM_NORMAL_MODE
    Return
h::Send, +{Left}
j::Send, +{Down}
k::Send, +{Up}
l::Send, +{Right}
0::Send, +{Home}
^::Send, +{Home}
$::Send, +{End}
y::
    Send, ^c
    Send, {Esc}
    mode := VIM_NORMAL_MODE
    Return
p::
    Send, ^v
    Send, {Esc}
    mode := VIM_NORMAL_MODE
    Return

#If

;===============================================================
;   VIM INPUT MODE
;===============================================================

#If (mode = VIM_INPUT_MODE)

Esc::
<^[::
    mode := VIM_NORMAL_MODE
    Return

#If

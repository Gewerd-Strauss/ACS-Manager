AddToolTip(ID="",TEXT="",TITLE="",OPTIONS="") {                                                        	;-- add ToolTips to controls - Advanced ToolTip features + Unicode
	

static
local option,a,b,c,d,e,f,g,h,i,k,l,m,n,o,p,q,r,s,t,v,w,x,y,xc,yc,xw,yw,RECT,_DetectHiddenWindows,OnMessage
If !Init
Gosub, TTM_INIT
OnMessage:=OnMessage(0x4e,"") ,_DetectHiddenWindows:=A_DetectHiddenWindows
DetectHiddenWindows, On
If !ID
{
If text
If text is Xdigit
GoTo, TTN_LINKCLICK
Loop, Parse, hWndArray, % Chr(2) ;Destroy all ToolTip Windows
{
If WinExist("ahk_id " . A_LoopField)
DllCall("DestroyWindow","Uint",A_LoopField)
hWndArray%A_LoopField%=
}
hWndArray=
Loop, Parse, idArray, % Chr(2) ;Destroy all ToolTip Structures
{
TT_ID:=A_LoopField
If TT_ALL_%TT_ID%
Gosub, TT_DESTROY
}
idArray=
Goto, TT_EXITFUNC
}

TT_ID:=ID
TT_HWND:=TT_HWND_%TT_ID%

;___________________  Load Options Variables and Structures ___________________

If (options) {
Loop,Parse,options,%A_Space%
If (option:= SubStr(A_LoopField,1,1))
%option%:= SubStr(A_LoopField,2)
}
If (G) {
If (Title!="") {
                        Gosub, TTM_SETTITLE
Gosub, TTM_UPDATE
}
If (Text!="") {
If (A!="")
ID:=A
If (InStr(text,"<a") and L){
TOOLTEXT_%TT_ID%:=text
text:=RegExReplace(text,"<a\K[^<]*?>",">")
} else
TOOLTEXT_%TT_ID%:=
NumPut(&text,TOOLINFO_%ID%,36)
Gosub, TTM_UPDATETIPTEXT
}
Loop, Parse,G,.
If IsLabel(A_LoopField)
Gosub, %A_LoopField%
Sleep,10
    Goto, TT_EXITFUNC
}
;__________________________  Save TOOLINFO Structures _________________________

If P {
If (p<100 and !WinExist("ahk_id " p)){
Gui,%p%:+LastFound
P:=WinExist()
}
If !InStr(TT_ALL_%TT_ID%,Chr(2) . Abs(P) . Chr(2))
TT_ALL_%TT_ID%  .= Chr(2) . Abs(P) . Chr(2)
}
If !InStr(TT_ALL_%TT_ID%,Chr(2) . ID . Chr(2))
TT_ALL_%TT_ID%  .= Chr(2) . ID . Chr(2)
If H
TT_HIDE_%TT_ID%:=1
;__________________________  Create ToolTip Window  __________________________

If (!TT_HWND and text) {
TT_HWND := DllCall("CreateWindowEx", "Uint", 0x8, "str", "tooltips_class32", "str", "", "Uint", 0x02 + (v ? 0x1 : 0) + (l ? 0x100 : 0) + (C ? 0x80 : 0)+(O ? 0x40 : 0), "int", 0x80000000, "int", 0x80000000, "int", 0x80000000, "int", 0x80000000, "Uint", P ? P : 0, "Uint", 0, "Uint", 0, "Uint", 0)
TT_HWND_%TT_ID%:=TT_HWND
hWndArray .=(hWndArray ? Chr(2) : "") . TT_HWND
idArray .=(idArray ? Chr(2) : "") . TT_ID
Gosub, TTM_SETMAXTIPWIDTH
DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x403, "Uint", 2, "Uint", (D ? D*1000 : -1)) ;TTDT_AUTOPOP
DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x403, "Uint", 3, "Uint", (W ? W*1000 : -1)) ;TTDT_INITIAL
DllCall("SendMessage", "Uint", TT_HWND, "Uint", 0x403, "Uint", 1, "Uint", (W ? W*1000 : -1)) ;TTDT_RESHOW
} else if (!text and !options){
DllCall("DestroyWindow","Uint",TT_HWND)
Gosub, TT_DESTROY
GoTo, TT_EXITFUNC
}

;______________________  Create TOOLINFO Structure  ______________________

Gosub, TT_SETTOOLINFO

If (Q!="")
Gosub, TTM_SETWINDOWTHEME
If (E!="")
Gosub, TTM_SETMARGIN
If (F!="")
Gosub, TTM_SETTIPTEXTCOLOR
If (B!="")
Gosub, TTM_SETTIPBKCOLOR
If (title!="")
Gosub, TTM_SETTITLE

If (!A) {
Gosub, TTM_UPDATETIPTEXT
Gosub, TTM_UPDATE
If D {
A_Timer := A_TickCount, D *= 1000
Gosub, TTM_TRACKPOSITION
Gosub, TTM_TRACKACTIVATE
Loop
{
Gosub, TTM_TRACKPOSITION
If (A_TickCount - A_Timer > D)
Break
}
Gosub, TT_DESTROY
DllCall("DestroyWindow","Uint",TT_HWND)
TT_HWND_%TT_ID%=
} else {
Gosub, TTM_TRACKPOSITION
Gosub, TTM_TRACKACTIVATE
If T
WinSet,Transparent,%T%,ahk_id %TT_HWND%
If M
WinSet,ExStyle,^0x20,ahk_id %TT_HWND%
}
}

;________  Return HWND of ToolTip  ________

Gosub, TT_EXITFUNC
Return TT_HWND

;________________________  Internal Labels  ________________________

TT_EXITFUNC:
If OnMessage
OnMessage(0x4e,OnMessage)
DetectHiddenWindows, %_DetectHiddenWindows%
Return
TTM_POP:  ;Hide ToolTip
TTM_POPUP:  ;Causes the ToolTip to display at the coordinates of the last mouse message.
TTM_UPDATE: ;Forces the current tool to be redrawn.
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", 0)
Return
TTM_TRACKACTIVATE: ;Activates or deactivates a tracking ToolTip.
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", (N ? 0 : 1), "Uint", &TOOLINFO_%ID%)
Return
TTM_UPDATETIPTEXT:
TTM_GETBUBBLESIZE:
TTM_ADDTOOL:
TTM_DELTOOL:
TTM_SETTOOLINFO:
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", &TOOLINFO_%ID%)
Return
TTM_SETTITLE:
title := (StrLen(title) < 96) ? title : (Chr(133) SubStr(title, -97))
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", I, "Uint", &Title)
Return
TTM_SETWINDOWTHEME:
If Q
DllCall("uxtheme\SetWindowTheme", "Uint", TT_HWND, "Uint", 0, "UintP", 0)
else
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", &K)
Return
TTM_SETMAXTIPWIDTH:
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", R ? R : A_ScreenWidth)
Return
TTM_TRACKPOSITION:
VarSetCapacity(xc, 20, 0), xc := Chr(20)
DllCall("GetCursorInfo", "Uint", &xc)
yc := NumGet(xc,16), xc := NumGet(xc,12)
SysGet,xl,76
SysGet,xr,78
SysGet,yl,77
SysGet,yr,79
xc+=15,yc+=15
If (x="caret" or y="caret") {
WinGetPos,xw,yw,,,A
If x=caret
{
xc:=xw+A_CaretX +1
xc:=(xl>xc ? xl : (xr<xc ? xr : xc))
}
If (y="caret"){
yc:=yw+A_CaretY+15
yc:=(yl>yc ? yl : (yr<yc ? yr : yc))
}
} else if (x="TrayIcon" or y="TrayIcon"){
Process, Exist
PID:=ErrorLevel
hWndTray:=WinExist("ahk_class Shell_TrayWnd")
ControlGet,hWndToolBar,Hwnd,,ToolbarWindow321,ahk_id %hWndTray%
RemoteBuf_Open(TrayH,hWndToolBar,20)
DataH:=NumGet(TrayH,0)
SendMessage, 0x418,0,0,,ahk_id %hWndToolBar%
Loop % ErrorLevel
{
SendMessage,0x417,A_Index-1,RemoteBuf_Get(TrayH),,ahk_id %hWndToolBar%
RemoteBuf_Read(TrayH,lpData,20)
VarSetCapacity(dwExtraData,8)
pwData:=NumGet(lpData,12)
DllCall( "ReadProcessMemory", "uint", DataH, "uint", pwData, "uint", &dwExtraData, "uint", 8, "uint", 0 )
BWID:=NumGet(dwExtraData,0)
WinGet,BWPID,PID, ahk_id %BWID%
If (BWPID!=PID and BWPID!=#__MAIN_PID_)
continue
SendMessage, 0x41d,A_Index-1,RemoteBuf_Get(TrayH),,ahk_id %hWndToolBar%
RemoteBuf_Read(TrayH,rcPosition,20)
If (NumGet(lpData,8)>7){
ControlGetPos,xc,yc,xw,yw,Button2,ahk_id %hWndTray%
xc+=xw/2, yc+=yw/4
} else {
ControlGetPos,xc,yc,,,ToolbarWindow321,ahk_id %hWndTray%
halfsize:=NumGet(rcPosition,12)/2
xc+=NumGet(rcPosition,0)+ halfsize
yc+=NumGet(rcPosition,4)+ (halfsize/2)
}
WinGetPos,xw,yw,,,ahk_id %hWndTray%
xc+=xw,yc+=yw
break
}
RemoteBuf_close(TrayH)
}
If xc not between %xl% and %xr%
xc=xc<xl ? xl : xr
If yc not between %yl% and %yr%
yc=yc<yl ? yl : yr
If (!x and !y)
Gosub, TTM_UPDATE
else if !WinActive("ahk_id " . TT_HWND)
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", (x<9999999 ? x : xc & 0xFFFF)|(y<9999999 ? y : yc & 0xFFFF)<<16)
Return
TTM_SETTIPBKCOLOR:
If B is alpha
If (%b%)
B:=%b%
B := (StrLen(B) < 8 ? "0x" : "") . B
B := ((B&255)<<16)+(((B>>8)&255)<<8)+(B>>16) ; rgb -> bgr
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", B, "Uint", 0)
Return
TTM_SETTIPTEXTCOLOR:
If F is alpha
If (%F%)
F:=%f%
F := (StrLen(F) < 8 ? "0x" : "") . F
F := ((F&255)<<16)+(((F>>8)&255)<<8)+(F>>16) ; rgb -> bgr
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint",F & 0xFFFFFF, "Uint", 0)
Return
TTM_SETMARGIN:
VarSetCapacity(RECT,16)
Loop,Parse,E,.
NumPut(A_LoopField,RECT,(A_Index-1)*4)
DllCall("SendMessage", "Uint", TT_HWND, "Uint", %A_ThisLabel%, "Uint", 0, "Uint", &RECT)
Return
TT_SETTOOLINFO:
If A {
If A is not Xdigit
ControlGet,A,Hwnd,,%A%,ahk_id %P%
ID :=Abs(A)
If !InStr(TT_ALL_%TT_ID%,Chr(2) . ID . Chr(2))
TT_ALL_%TT_ID%  .= Chr(2) . ID . Chr(2) . ID+Abs(P) . Chr(2)
If !TOOLINFO_%ID%
VarSetCapacity(TOOLINFO_%ID%, 40, 0),TOOLINFO_%ID%:=Chr(40)
else
Gosub, TTM_DELTOOL
Numput((N ? 0 : 1)|(J ? 2 : 0)|(L ? 0x1000 : 0)|16,TOOLINFO_%ID%,4),Numput(P,TOOLINFO_%ID%,8),Numput(ID,TOOLINFO_%ID%,12)
If (text!="")
NumPut(&text,TOOLINFO_%ID%,36)
Gosub, TTM_ADDTOOL
      ID :=ID+Abs(P)
If !TOOLINFO_%ID%
{
VarSetCapacity(TOOLINFO_%ID%, 40, 0),TOOLINFO_%ID%:=Chr(40)
Numput(0|16,TOOLINFO_%ID%,4), Numput(P,TOOLINFO_%ID%,8), Numput(P,TOOLINFO_%ID%,12)
}
Gosub, TTM_ADDTOOL
ID :=Abs(A)
} else {
If !TOOLINFO_%ID%
VarSetCapacity(TOOLINFO_%ID%, 40, 0),TOOLINFO_%ID%:=Chr(40)
If (text!=""){
If InStr(text,"<a"){
TOOLTEXT_%ID%:=text
text:=RegExReplace(text,"<a\K[^<]*?>",">")
} else
TOOLTEXT_%ID%:=
NumPut(&text,TOOLINFO_%ID%,36)
}
      NumPut((J ? 2 : 0)|(!(x . y) ? 0 : 0x20)|(S ? 0x80 : 0)|(L ? 0x1000 : 0),TOOLINFO_%ID%,4), Numput(P,TOOLINFO_%ID%,8), Numput(P,TOOLINFO_%ID%,12)
Gosub, TTM_ADDTOOL
}
    TOOLLINK%ID%:=L
  Return
TTN_LINKCLICK:
Loop 4
m += *(text + 8 + A_Index-1) << 8*(A_Index-1)
If !(TTN_FIRST-2=m or TTN_FIRST-3=m or TTN_FIRST-1=m)
Return, OnMessage ? OnMessage(0x4e,OnMessage) : 0
Loop 4
p += *(text + 0 + A_Index-1) << 8*(A_Index-1)
If (TTN_FIRST-3=m)
Loop 4
option += *(text + 16 + A_Index-1) << 8*(A_Index-1)
Loop,Parse,hWndArray,% Chr(2)
If (p=A_LoopField and i:=A_Index)
break
Loop,Parse,idArray,% Chr(2)
{
If (i=A_Index){
If (TTN_FIRST-1=m){
Loop 4
ErrorLevel += *(text + 4 + A_Index-1) << 8*(A_Index-1)
Return A_LoopField, OnMessage ? OnMessage(0x4e,OnMessage) : 0
}
text:=TOOLTEXT_%A_LoopField%
If (TTN_FIRST-2=m){
If Title
{
If IsLabel(A_LoopField . title . "Close")
Gosub % A_LoopField . title . "Close"
else If IsLabel(title . "Close")
Gosub % title . "Close"
} else {
If IsLabel(A_LoopField . A_ThisFunc . "Close")
Gosub % A_LoopField . A_ThisFunc . "Close"
else If IsLabel(A_ThisFunc . "Close")
Gosub % A_ThisFunc . "Close"
}
} else If (InStr(TOOLTEXT_%A_LoopField%,"<a")){
Loop % option+1
StringTrimLeft,text,text,% InStr(text,"<a")+1
If TT_HIDE_%A_LoopField%
%A_ThisFunc%(A_LoopField,"","","gTTM_POP")
If ((a:=A_AutoTrim)="Off")
AutoTrim, On
ErrorLevel:=SubStr(text,1,InStr(text,">")-1)
StringTrimLeft,text,text,% InStr(text,">")
text:=SubStr(text,1,InStr(text,"</a>")-1)
If !ErrorLevel
ErrorLevel:=text
ErrorLevel=%ErrorLevel%
AutoTrim, %a%
If Title
{
If IsFunc(f:=(A_LoopField . title))
%f%(ErrorLevel)
else if IsLabel(A_LoopField . title)
Gosub % A_LoopField . title
else if IsFunc(title)
%title%(ErrorLevel)
else If IsLabel(title)
Gosub, %title%
} else {
if IsFunc(f:=(A_LoopField . A_ThisFunc))
%f%(ErrorLevel)
else If IsLabel(A_LoopField . A_ThisFunc)
Gosub % A_LoopField . A_ThisFunc
else If IsLabel(A_ThisFunc)
Gosub % A_ThisFunc
}
}
break
}
}
DetectHiddenWindows, %_DetectHiddenWindows%
Return OnMessage ? OnMessage(0x4e,OnMessage) : 0
TT_DESTROY:
Loop, Parse, TT_ALL_%TT_ID%,% Chr(2)
If A_LoopField
{
ID:=A_LoopField
Gosub, TTM_DELTOOL
TOOLINFO_%A_LoopField%:="", TT_HWND_%A_LoopField%:="", TOOLTEXT_%A_LoopField%:="", TT_HIDE_%A_LoopField%:="",TOOLLINK%A_LoopField%:=""
}
TT_ALL_%TT_ID%=
Return

TTM_INIT:
Init:=1
; Messages
TTM_ACTIVATE := 0x400 + 1, TTM_ADDTOOL := A_IsUnicode ? 0x432 : 0x404, TTM_DELTOOL := A_IsUnicode ? 0x433 : 0x405
,TTM_POP := 0x41c, TTM_POPUP := 0x422, TTM_UPDATETIPTEXT := 0x400 + (A_IsUnicode ? 57 : 12)
,TTM_UPDATE := 0x400 + 29, TTM_SETTOOLINFO := 0x409, TTM_SETTITLE := 0x400 + (A_IsUnicode ? 33 : 32)
,TTN_FIRST := 0xfffffdf8, TTM_TRACKACTIVATE := 0x400 + 17, TTM_TRACKPOSITION := 0x400 + 18
,TTM_SETMARGIN:=0x41a, TTM_SETWINDOWTHEME:=0x200b, TTM_SETMAXTIPWIDTH:=0x418,TTM_GETBUBBLESIZE:=0x41e
,TTM_SETTIPBKCOLOR:=0x413, TTM_SETTIPTEXTCOLOR:=0x414
;Colors
,Black:=0x000000, Green:=0x008000,Silver:=0xC0C0C0
,Lime:=0x00FF00, Gray:=0x808080, Olive:=0x808000
,White:=0xFFFFFF, Yellow:=0xFFFF00, Maroon:=0x800000
,Navy:=0x000080, Red:=0xFF0000, Blue:=0x0000FF
,Purple:=0x800080, Teal:=0x008080, Fuchsia:=0xFF00FF
   ,Aqua:=0x00FFFF
Return
}
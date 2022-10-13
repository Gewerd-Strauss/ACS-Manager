AddToolTip(ID="",TEXT="",TITLE="",OPTIONS="") {                                                        	;-- add ToolTips to controls - Advanced ToolTip features + Unicode
	/*					DESCRIPTION
ToolTip() by HotKeyIt http://www.autohotkey.com/forum/viewtopic.php?t=40165

Syntax: ToolTip(Number,Text,Title,Options)

Return Value: ToolTip returns hWnd of the ToolTip

|         Options can include any of following parameters separated by space
| Option   |      Meaning
| A      		|   Aim ConrolId or ClassNN (Button1, Edit2, ListBox1, SysListView321...)
|         		|   - using this, ToolTip will be shown when you point mouse on a control
|         		|   - D (delay) can be used to change how long ToolTip is shown
|         		|   - W (wait) can wait for specified seconds before ToolTip will be shown
|         		|   - Some controls like Static require a subroutine to have a ToolTip!!!
| B + F   	|   Specify here the color for ToolTip in 6-digit hexadecimal RGB code
|        		|   - B = Background color, F = Foreground color (text color)
|        		|   - this can be 0x00FF00 or 00FF00 or Blue, Lime, Black, White...
| C     		|   Close button for ToolTip/BalloonTip. See ToolTip actions how to use it
| D     		|   Delay. This option will determine how long ToolTip should be shown.30 sec. is maximum
|        		|   - this option is also available when assigning the ToolTip to a control.
| E      		|   Edges for ToolTip, Use this to set margin of ToolTip window (space between text and border)
|        		|   - Supply Etop.left.bottom.right in pixels, for example: E10.0.10.5
| G     		|   Execute one or more internal Labels of ToolTip function only.
|        		|   For example:
|        		|   - Track the position only, use ToolTip(1,"","","Xcaret Ycaret gTTM_TRACKPOSITION")
|        		|      - When X+Y are empty (= display near mouse position) you can use TTM_UPDATE
|        		|   - Update text only, use ToolTip(1,"text","","G1"). Note specify L1 if links are used.
|        		|   - Update title only, use ToolTip(1,"","Title","G1")
|        		|   - Hide ToolTip, use ToolTip(1,"","","gTTM_POP")
|        		|      - To show ToolTip again use ToolTip(1,"","","gTTM_TRACKPOSITION.TTM_TRACKACTIVATE")
|        		|   - Update background color + text color, specify . between gLabels to execute several:
|        		|      - ToolTip(1,"","","BBlue FWhite gTTM_SETTIPBKCOLOR.TTM_SETTIPTEXTCOLOR")
|        		|   - Following labels can be used: TTM_SETTITLEA + TTM_SETTITLEW (title+I), TTM_POPUP, TTM_POP
|        		|     TTM_SETTIPBKCOLOR (B), TTM_SETTIPTEXTCOLOR (F), TTM_TRACKPOSITION (N+X+Y),
|        		|     TTM_SETMAXTIPWIDTH (R), TTM_SETMARGIN (E), TT_SETTOOLINFO (text+A+P+N+X+Y+S+L)
|        		|     TTM_SETWINDOWTHEME (Q)
| H     		|   Hide ToolTip after a link is clicked.See L option
| I     		|   Icon 1-3, e.g. I1. If this option is missing no Icon will be used (same as I0)
|       		|   - 1 = Info, 2 = Warning, 3 = Error, > 3 is meant to be a hIcon (handle to an Icon)
|       		|   Use Included MI_ExtractIcon and GetAssociatedIcon functions to get hIcon
| J     		|   Justify ToolTip to center of control
| L     		|   Links for ToolTips. See ToolTip actions how Links for ToolTip work.
| M   		|   Mouse click-trough. So a click will be forwarded to the window underneath ToolTip
| N    		|   Do NOT activate ToolTip (N1), To activate (show) call ToolTip(1,"","","gTTM_TRACKACTIVATE")
| O    		|   Oval ToolTip (BalloonTip). Specify O1 to use a BalloonTip instead of ToolTip.
| P    		|   Parent window hWnd or GUI number. This will assign a ToolTip to a window.
|       		|   - Reqiered to assign ToolTip to controls and actions.
| Q    		|   Quench Style/Theme. Use this to disable Theme of ToolTip.
|       		|   Using this option you can have for example colored ToolTips in Vista.
| R    		|   Restrict width. This will restrict the width of the ToolTip.
|       		|   So if Text is to long it will be shown in several lines
| S    		|   Show at coordinates regardless of position. Specify S1 to use that feature
|       		|   - normally it is fed automaticaly to show on screen
| T    		|   Transparency. This option will apply Transparency to a ToolTip.
|       		|   - this option is not available to ToolTips assigned to a control.
| V    		|   Visible: even when the parent window is not active, a control-ToolTip will be shown
| W   		|   Wait time in seconds (max 30) before ToolTip pops up when pointing on one of controls.
| X + Y   	|   Coordinates where ToolTip should be displayed, e.g. X100 Y200
|         		|   - leave empty to display ToolTip near mouse
|         		|   - you can specify Xcaret Ycaret to display at caret coordinates
|
|          		To destroy a ToolTip use ToolTip(Number), to destroy all ToolTip()
|
|               ToolTip Actions (NOTE, OPTION P MUST BE PRESENT TO USE THAT FEATURE)
|      			Assigning an action to a ToolTip to works using OnMessage(0x4e,"Function") - WM_NOTIFY
|      			Parameter/option P must be present so ToolTip will forward messages to script
|      			All you need to do inside this OnMessage function is to include:
|         		- If wParam=0
|            	ToolTip("",lParam[,Label])
|
|  			    Additionally you need to have one or more of following labels in your script
|  			    - ToolTip: when clicking a link
|  			    - ToolTipClose: when closing ToolTip
|  			       - You can also have a diferent label for one or all ToolTips
|  			       - Therefore enter the number of ToolTip in front of the label
|  			          - e.g. 99ToolTip: or 1ToolTipClose:
|
|  			    - Those labels names can be customized as well
|  			       - e.g. ToolTip("",lParam,"MyTip") will use MyTip: and MyTipClose:
|  			       - you can enter the number of ToolTip in front of that label as well.
|
|  			    - Links have following syntax:
|  			       - <a>Link</a> or <a link>LinkName</a>
|  			       - When a Link is clicked, ToolTip() will jump to the label
|  			          - Variable ErrorLevel will contain clicked link
|
|  			       - So when only LinkName is given, e.g. <a>AutoHotkey</a> Errorlevel will be AutoHotkey
|  			       - When using Link is given as well, e.g. <a http://www.autohotkey.com>AutoHotkey</a>
|  			          - Errorlevel will be set to http://www.autohotkey.com
|
|  			    Please note some options like Close Button and Links will require Win2000++ (+version 6.0 of comctl32.dll)
|  			      AutoHotKey Version 1.0.48++ is required due to "assume static mode"
|  			      If you use 1 ToolTip for several controls, the only difference between those can be the text.
|  			         - Other options, like Title, color and so on, will be valid globally
*/

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

;______________________  Create TOOLINFO Structure  __
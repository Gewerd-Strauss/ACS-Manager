/*
    Regex Example
*/
haystack =
(
LI:wtf
AU:ADwd
LI:wtf v312
SE:menu
AHK-VERSION:
v1 and ?v2?

AUTHOR:
DRocks and justme

DATE:
18.02.2019

DEPENDENCIES:
GetGuiClassStyle(), SetGuiClassStyle(HGUI, Style)

KEYWORDS:
gui, style, shadow

LINK:
https://www.autohotkey.com/boards/viewtopic.php?f=6&p=264108#p264108

REMARK(S):
tested on Windows 7


)
; (LI|AU|SE):(.+?)`n
; pos := 1
; needle := "(([[:upper:]]|-|:| |\(|\))*\n)"
; while (RegExMatch(haystack, "im)" needle, match, pos)) {
;     d(match1, match2)
;     pos += StrLen(match)
; }
 
;===============================================================================
 
/*
    OnMessage Example
*/
Gui MyGui:New, ToolWindow
Gui Add, Edit, w135 vCheckMe
Gui Show, w155, Test
OnMessage(0x0101, "KeyDown") ; WM_KEYDOWN
 
return
 
KeyDown(wParam, lParam, Msg, hWnd) {
    static last := 0
    GuiControlGet name, MyGui:Name, % hWnd
    if (name != "CheckMe")
        return
    diff := A_Now
    diff -= last, Seconds
    last := A_Now
    ttip("Seconds since last 'Edit1' input: " diff)
}
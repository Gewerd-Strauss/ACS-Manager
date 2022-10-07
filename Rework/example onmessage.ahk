/*
    Regex Example
*/
haystack =
(
LI:wtf
AU:ADwd
LI:wtf v312
SE:menu
)
; pos := 1
; needle := "(LI|AU|SE):(.+?)`n"
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
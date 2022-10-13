ToggleFakeFullscreen() {																				            	;-- sets styles to a window to look like a fullscreen

    CoordMode Screen, Window
    static WINDOW_STYLE_UNDECORATED := -0xC40000
    static savedInfo := Object() ;; Associative array!
    WinGet, id, ID, A

    if (savedInfo[id]) {
        inf := savedInfo[id]
        WinSet, Style, % inf["style"], ahk_id %id%
        WinMove, ahk_id %id%,, % inf["x"], % inf["y"], % inf["width"], % inf["height"]
        savedInfo[id] := ""
    } else {
        savedInfo[id] := inf := Object()
        WinGet, ltmp, Style, A
        inf["style"] := ltmp
        WinGetPos, ltmpX, ltmpY, ltmpWidth, ltmpHeight, ahk_id %id%
        inf["x"] := ltmpX
        inf["y"] := ltmpY
        inf["width"] := ltmpWidth
        inf["height"] := ltmpHeight
        WinSet, Style, %WINDOW_STYLE_UNDECORATED%, ahk_id %id%
        mon := GetMonitorActiveWindow()
        SysGet, mon, Monitor, %mon%
        WinMove, A,, %monLeft%, %monTop%, % monRight-monLeft, % monBottom-monTop
    }
    WinSet Redraw
}
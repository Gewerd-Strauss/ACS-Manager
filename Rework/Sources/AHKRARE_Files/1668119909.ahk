GetWindowCoords(hWnd, ByRef x, ByRef y) {																;--
    hParent := GetParent(hWnd)
    WinGetPos px, py,,, % "ahk_id" . (hParent == 0 ? hWnd : hParent)
    x := x - px
    y := y - py
}
GetWindowInfo(hWnd) {                                                                                         	;-- returns an Key:Val Object with the most informations about a window (Pos, Client Size, Style, ExStyle, Border size...)
    NumPut(VarSetCapacity(WINDOWINFO, 60, 0), WINDOWINFO)
    DllCall("GetWindowInfo", "Ptr", hWnd, "Ptr", &WINDOWINFO)
    wi := Object()
    wi.WinX := NumGet(WINDOWINFO, 4, "Int")
    wi.WinY := NumGet(WINDOWINFO, 8, "Int")
    wi.WinW := NumGet(WINDOWINFO, 12, "Int") - wi.WindowX
    wi.WinH := NumGet(WINDOWINFO, 16, "Int") - wi.WindowY
    wi.cX := NumGet(WINDOWINFO, 20, "Int")
    wi.cY := NumGet(WINDOWINFO, 24, "Int")
    wi.cW := NumGet(WINDOWINFO, 28, "Int") - wi.ClientX
    wi.cH := NumGet(WINDOWINFO, 32, "Int") - wi.ClientY
    wi.Style   := NumGet(WINDOWINFO, 36, "UInt")
    wi.ExStyle := NumGet(WINDOWINFO, 40, "UInt")
    wi.Active  := NumGet(WINDOWINFO, 44, "UInt")
    wi.BorderW := NumGet(WINDOWINFO, 48, "UInt")
    wi.BorderH := NumGet(WINDOWINFO, 52, "UInt")
    wi.Atom    := NumGet(WINDOWINFO, 56, "UShort")
    wi.Version := NumGet(WINDOWINFO, 58, "UShort")
    Return wi
}
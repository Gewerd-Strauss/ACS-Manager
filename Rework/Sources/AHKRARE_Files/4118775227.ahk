GetClientCoords(hWnd, ByRef x, ByRef y) {																	;--
    VarSetCapacity(POINT, 8, 0)
    NumPut(x, POINT, 0, "Int")
    NumPut(y, POINT, 4, "Int")
    hParent := GetParent(hWnd)
    DllCall("ScreenToClient", "Ptr", (hParent == 0 ? hWnd : hParent), "Ptr", &POINT)
    x := NumGet(POINT, 0, "Int")
    y := NumGet(POINT, 4, "Int")
}
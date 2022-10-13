GetAncestor(hWnd, Flag := 2) {																					;--
    Return DllCall("GetAncestor", "Ptr", hWnd, "UInt", Flag)
}
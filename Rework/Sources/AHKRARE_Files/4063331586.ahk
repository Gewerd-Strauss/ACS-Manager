GetWindowPos(hWnd, ByRef X, ByRef Y, ByRef W, ByRef H) {										;--
    VarSetCapacity(RECT, 16, 0)
    DllCall("GetWindowRect", "Ptr", hWnd, "Ptr", &RECT)
    DllCall("MapWindowPoints", "Ptr", 
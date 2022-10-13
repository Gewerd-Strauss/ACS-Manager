GetWindowPlacement(hWnd) {																					;-- Gets window position using workspace coordinates (-> no taskbar), returns an object
    VarSetCapacity(WINDOWPLACEMENT, 44, 0)
    NumPut(44, WINDOWPLACEMENT)
    DllCall("GetWindowPlacement", "Ptr", hWnd, "Ptr", &WINDOWPLACEMENT)
    Result := {}
    Result.x := NumGet(WINDOWPLACEMENT, 7 * 4, "UInt")
    Result.y := NumGet(WINDOWPLACE
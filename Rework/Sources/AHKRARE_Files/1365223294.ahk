GetWindowLong(hWnd, Param) {																				;--

    ;GetWindowLong := A_PtrSize == 8 ? "GetWindowLongPtr" : "GetWindowLong"
    Return DllCall("GetWindowLong", "Ptr", hWnd, "int", Param)
}
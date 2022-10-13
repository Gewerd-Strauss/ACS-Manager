GetClassLong(hWnd, Param) {																					;--

    Static GetClassLong := A_PtrSize == 8 ? "GetClassLongPtr" : "GetClassLong"
    Return DllCall(GetClassLong, "Ptr
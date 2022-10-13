IsWindow(hWnd) {																										;-- wrapper for IsWindow DllCall
    Return DllCall("IsWindow", "Ptr", hWnd)
}
CaptureWindow(hwndOwner, hwnd) {                                                                	;-- screenshot function 3

    VarSetCapacity(RECT, 16, 0)
    DllCall("GetWindowRect", "Ptr", hwnd, "Ptr", &RECT)
    width  := NumGet(RECT, 8, "Int")  - NumGet(RECT, 0, "Int")
    height := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")

    hdc    := DllCall("GetDC", "Ptr", 0, "Ptr")
    hdcMem := DllCall("CreateCompatibleDC", "Ptr", hdc, "UPtr")
    hBmp   := DllCall("CreateCompatibleBitmap", "Ptr", hdc, "Int", width, "Int", height, "UPtr")
    hdcOld := DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hBmp)

    DllCall("BitBlt", "Ptr", hdcMem
        , "Int", 0, "Int", 0, "Int", width, "Int", height
        , "Ptr", hdc, "Int", Numget(RECT, 0, "Int"), "Int", Numget(RECT, 4, "Int")
        , "UInt", 0x00CC0020) ; SRCCOPY

    DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hdcOld)

    DllCall("OpenClipboard", "Ptr", hwndOwner) ; Clipboard owner
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "uint", 0x2, "Ptr", hBmp) ; CF_BITMAP
    DllCall("CloseClipboard")

    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdc)

    Return True
}
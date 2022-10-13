Gdip_GetHICONDimensions(hIcon, ByRef Width, ByRef Height) {                   	;-- get icon dimensions
    Ptr := A_PtrSize ? "Ptr" : "UInt"
    Width := Height := 0

    VarSetCapacity(ICONINFO, size := 16 + 2 * A_PtrSize, 0)

    if !DllCall("User32\GetIconInfo", Ptr, hIcon, Ptr, &ICONINFO)
        return

    hbmMask := NumGet(&ICONINFO, 16, Ptr)
    hbmColor := NumGet(&ICONINFO, 16 + A_PtrSize, Ptr)
    VarSetCapacity(BITMAP, size, 0)

    if DllCall("Gdi32\GetObject", Ptr, hbmColor, "Int", size, Ptr, &BITMAP)
    {
	    Width := NumGet(&BITMAP, 4, "Int")
	    Height := NumGet(&BITMAP, 8, "Int")
    }

    DllCall("Gdi32\DeleteObject", Ptr, hbmMask)
    DllCall("Gdi32\DeleteObject", Ptr, hbmColor)
}
GetBitmapSize(h_bitmap, ByRef width, ByRef height, ByRef bpp="") {                	;-- Lexikos function to get the size of bitmap
    VarSetCapacity(bm, 24, 0) ; BITMAP
    if (!DllCall("GetObject", "UInt", h_bitmap, "Int", 24, "UInt", &bm))
        return false
    width  := NumGet(bm, 4, "int")
    height := NumGet(bm, 8, "int")
    bpp    := NumGet(bm,18, "ushort")
    return true
}
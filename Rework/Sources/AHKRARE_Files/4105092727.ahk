AddGraphicButtonPlus(ImgPath, Options="", Text="") {											;-- GDI+ add a graphic button to a gui

	hGdiPlus := DllCall("LoadLibrary", "Str", "gdiplus.dll")
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "UIntP", pToken, "UInt", &si, "UInt", 0)
	VarSetCapacity(wFile, StrLen(ImgPath)*2+2)
	DllCall("kernel32\MultiByteToWideChar", "UInt", 0, "UInt", 0, "Str", ImgPath, "Int", -1, "UInt", &wFile, "Int", VarSetCapacity(wFile)//2)
	DllCall("gdiplus\GdipCreateBitmapFromFile", "UInt", &wFile, "UIntP", pBitmap)
	if (pBitmap) {
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UInt", pBitmap, "UIntP", hBM, "UInt", 0)
	DllCall("gdiplus\GdipDisposeImage", "Uint", pBitmap)
	}
	DllCall("gdiplus\GdiplusShutdown" , "UInt", pToken)
	DllCall("FreeLibrary", "UInt",
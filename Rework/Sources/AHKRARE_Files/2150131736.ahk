CopyBitmapOnGraphic(pGraphics,pBitmap,w,h) {                                               	;-- copy a pBitmap of a specific width and height to the Gdip graphics container (pGraphics)
return DllCall("gdiplus\GdipDrawImageRectRect", "uint", pGraphics, "uint", pBitmap
	, "float", 0, "float", 0, "float", w, "float", h
	, "float", 0, "float", 0, "float", w, "float", h
	, "int", 2, "uint", 0, "uint", 0, "uint", 0)
}
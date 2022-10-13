GetBitmapFromAnything(Anything) {                                                                 	;-- Supports paths, icon handles and hBitmaps

	if(FileExist(Anything))
	{
		pBitmap := Gdip_CreateBitmapFromFile(Anything)
		;hBitmap := Gdip_CreateHBitmapFromBitmap(pBitmap)
		;Gdip_DisposeImage(pBitmap)
	}
	else if(DllCall("GetObjectType", "PTR", hBitmap) = (OBJ_BITMAP := 7)) ;Tread as icon
	{
		hBitmap := Anything
		pBitmap := Gdip_CreateBitmapFromHBitmap(hBitmap)
		DeleteObject(hBitmap)
	}
	else if(Anything != "")
	{
		pBitmap := Gdip_CreateBitmapFromHICON(Anything)
		;hBitmap := Gdip_CreateHBitmapFromBitmap(pBitmap)
		;Gdip_DisposeImage(pBitmap)
	}
	else
		return 0
	return pBitmap
}
CircleCrop(pBitmap, x, y, w, h) {                                                                           	;-- gdi circlecrop with MCode
	static _CircleCrop
	if !_CircleCrop
	{
		MCode_CircleCrop := "8B44241C9983E20303C28BC88B4424209983E20303C28B542418C1F902C1F80285D27E6803C003C0894424208D048D000000000"
		. "FAF4C2428034C2424535556894424288B442410578B7C24188BDA8B5424248D348885D27E228BC78BCE8D49008B29332883C10481E5FFFFFF00312883"
		. "C00483EA0175E98B5424240374242C037C243083EB0175CD5F5E5D5B33C0C3"

		VarSetCapacity(_CircleCrop, StrLen(MCode_CircleCrop)//2)
		Loop % StrLen(MCode_CircleCrop)//2      ;%
			NumPut("0x" SubStr(MCode_CircleCrop, (2*A_Index)-1, 2), _CircleCrop, A_Index-1, "char")
	}
	Gdip_GetDimensions(pBitmap, w1, h1)
	pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetSmoothingMode(G2, 4)

	pBrush := Gdip_BrushCreateSolid(0xff00ff00)
	Gdip_FillEllipse(G2, pBrush, 0, 0, w, h)
	Gdip_DeleteBrush(pBrush)

	E1 := Gdip_LockBits(pBitmap, 0, 0, w1, h1, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmap2, 0, 0, w, h, Stride2, Scan02, BitmapData2)

	E := DllCall(&_CircleCrop, "ptr", Scan01, "ptr", Scan02, "int", w1, "int", h1, "int", w, "int", h, "int", Stride1, "int", Stride2, "int", x, "int", y)

	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmap2, BitmapData2)
	Gdip_DeleteGraphics(G2)
	return pBitmap2
}
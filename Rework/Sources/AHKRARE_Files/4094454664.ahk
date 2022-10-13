hBMPFromPNGBuffer(ByRef Buffer, width, height) {                                                   	;-- Function provides a hBitmap handle e.g. from a resource previously loaded into memory (LoadScriptResource)

	;modified SKAN's code ; http://www.autohotkey.com/forum/post-147052.html#147052

	; for AutoHotkey Basic users
	; Ptr := A_PtrSize ? "Ptr" : "Uint" , PtrP := A_PtrSize ? "PtrP" : "UIntP"

	nSize := StrLen(Buffer) * 2 ;// 2 ; <-- I don't understand why it has to be multiplied by 2
	hData := DllCall("GlobalAlloc", UInt, 2, UInt, nSize, Ptr)
	pData := DllCall("GlobalLock", Ptr, hData , Ptr)
	DllCall( "RtlMoveMemory", Ptr, pData, Ptr,&Buffer, UInt,nSize )
	DllCall( "GlobalUnlock", Ptr, hData )
	DllCall( "ole32\CreateStreamOnHGlobal", Ptr, hData, Int, True, PtrP, pStream )
	DllCall( "LoadLibrary", Str,"gdiplus" )
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall( "gdiplus\GdiplusStartup", PtrP, pToken, Ptr, &si, UInt,0 )
	DllCall( "gdiplus\GdipCreateBitmapFromStream", Ptr, pStream, PtrP, pBitmap )
	DllCall( "gdiplus\GdipCreateHBITMAPFromBitmap", Ptr,pBitmap, PtrP, hBitmap, UInt,0)

	hNewBitMap := DllCall("CopyImage"
          , Ptr, hBitmap
          , UInt, 0
          , Int, width
          , Int, height
          , UInt, 0x00000008      ;LR_COPYDELETEORG
          , Ptr)

	DllCall( "gdiplus\GdipDisposeImage", Ptr, pBitmap )
	DllCall( "gdiplus\GdiplusShutdown", Ptr, pToken )
	DllCall( NumGet(NumGet(1*pStream)+8), Ptr, pStream )

	Return hNewBitMap
}
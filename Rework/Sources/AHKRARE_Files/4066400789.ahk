GDI_GrayscaleBitmap( hBM ) {                                                                            	;-- Converts GDI bitmap to 256 color GreyScale

	; www.autohotkey.com/community/viewtopic.php?t=88996    By SKAN,  Created : 19-Jul-2012

	Static RGBQUAD256

	If ! VarSetCapacity( RGBQUAD256 ) {
		VarSetCapacity( RGBQUAD256, 256*4, 0 ),  Color := 0
		Loop 255
			Numput( Color := Color + 0x010101, RGBQUAD256, A_Index*4, "UInt" )
	}

	VarSetCapacity( BM,24,0 ),  DllCall( "GetObject", UInt,hBM, UInt,24, UInt,&BM )
	W := NumGet( BM,4 ), H := NumGet( BM,8 )

	hdcSrc := DllCall( "CreateCompatibleDC", UInt,0 )
	hbmPrS := DllCall( "SelectObject", UInt,hdcSrc, UInt,hBM )

	dBM := DllCall( "CopyImage", UInt
				, DllCall( "CreateBitmap", Int,2, Int,2, UInt,1, UInt,8, UInt,0 )
				, UInt,0, Int,W, Int,H, UInt,0x2008, UInt )

	hdcDst  := DllCall( "CreateCompatibleDC", UInt,0 )
	hbmPrD  := DllCall( "SelectObject", UInt,hdcDst, UInt,dBM )
	DllCall( "SetDIBColorTable", UInt,hdcDst, UInt,0, UInt,256, UInt,&RGBQUAD256 )

	DllCall( "BitBlt", UInt,hdcDst, Int,0, Int,0, Int,W, Int,H
                  , UInt,hdcSrc, Int,0, Int,0, UInt,0x00CC0020 )

	DllCall( "SelectObject", UInt,hdcSrc, UInt,hbmPrS )
	DllCall( "DeleteDC",     UInt,hdcSrc )
	DllCall( "SelectObject", UInt,hdcSrc, UInt,hbmPrD )
	DllCall( "DeleteDC",     UInt,hdcDst )

Return dBM
}
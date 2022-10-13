Gdi_ExtFloodFill(hDC, XStart, YStart, Color, FillType=0) {                                    	;-- fills an area with the current brush
	return DllCall( "GDI32\ExtFloodFill", (A_PtrSize ? "UPtr" : "UInt"), hDC
		 , int, XStart, int, YStart, UInt, Color ; color is in ARGB form
		 , UInt, FillType, "int" )
}
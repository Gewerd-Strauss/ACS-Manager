GuiDefaultFont() {                                                                                                        	;-- returns the default Fontname & Fontsize
	 hFont := DllCall( "GetStockObject", UInt,17 ) ; DEFAULT_GUI_FONT
	 VarSetCapacity( LF, szLF := 60*( A_IsUnicode ? 2:1 ) )
	 DllCall("GetObject", UInt,hFont, Int,szLF, UInt,&LF )
	 hDC := DllCall( "GetDC", UInt,hwnd ), DPI := DllCall( "GetDeviceCaps", UInt,hDC, Int,90 )
	 DllCall( "ReleaseDC", Int,0, UInt,hDC ), S := Round( ( -NumGet( LF,0,"Int" )*72 ) / DPI )
Return DllCall( "MulDiv",Int,&LF+28, Int,1,Int,1, Str ), DllCall( "SetLastError", UInt,S )
}
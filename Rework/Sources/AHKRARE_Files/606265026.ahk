GuiDefaultFont() {                                                                                                        	;-- returns the default Fontname & Fontsize
	 hFont := DllCall( "GetStockObject", UInt,17 ) ; DEFAULT_GUI_FONT
	 VarSetCapacity( LF, szLF := 60*( A_IsUnicode ? 2:1 ) )
	 DllCall("GetObject", UInt,hFont, Int,szLF, UInt,&LF )
	 hDC := DllCall( "GetDC", UInt,hwnd ), DPI := DllCall( "Get
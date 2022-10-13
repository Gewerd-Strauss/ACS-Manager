Menu_Show( hMenu, hWnd=0, mX="", mY="", Flags=0x1 ) {                                	;-- its an alternative to Menu, Show, which can display menu without blocking monitored messages
	 ; Flags: TPM_RECURSE := 0x1, TPM_RETURNCMD := 0x100, TPM_NONOTIFY := 0x80
	 VarSetCapacity( POINT, 8, 0 ), DllCall( "GetCursorPos", UInt,&Point )
	 mX := ( mX <> "" ) ? mX : NumGet( Point,0 )
	 mY := ( mY <> "" ) ? mY : NumGet( Point,4 )

Return DllCall( "TrackPopupMenu", UInt,hMenu, UInt,Flags, Int,mX, Int,mY, UInt,0, UInt,hWnd ? hWnd : WinActive("A"), UInt,0 ) ; TrackPopupMenu()  goo.gl/CosNig
}
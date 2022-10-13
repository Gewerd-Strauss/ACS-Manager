RMApp_NCHITTEST() {                                                                                            	;-- Determines what part of a window the mouse is currently over

	/*                         	DESCRIPTON
		Function: RMApp_NCHITTEST()
		Determines what part of a window the mouse is currently over.
	*/

	CoordMode, Mouse, Screen
	MouseGetPos, x, y, z
	SendMessage, 0x84, 0, (x&0xFFFF)|(y&0xFFFF)<<16,, ahk_id %z%
	RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" ErrorLev
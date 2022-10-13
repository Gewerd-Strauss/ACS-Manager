LV_Find( lvhwnd, str, start = 0 ) { 	        																		;-- I think it's usefull to find an item position a listview
	;Copyright © 2013 VxE. All rights reserved.
	Static LVFI_STRING := 2, LVFI_SUBSTRING := 4
	LVM_FINDITEM := A_IsUnicode = 1 ? 0x1053 : 0x100D
	oel := ErrorLevel
	start |= 0
	If ( partial := ( SubStr( str, 0 ) = "*" ? LVFI_SUBSTRING : 0 ) )
	StringTrimRight str, str, 1
	VarSetCapacity( LVFINDINFO, 12 + 3 * ( A_PtrSize = 8 ? 8 : 4 ), 0 )
	NumPut( LVFI_STRING | partial, LVFINDINFO, 0, "UInt" )
	NumPut( &str, LVFINDINFO, 4 )
	SendMessage, LVM_FINDITEM, % start < 0 ? -1 : start - 1, &LVFINDINFO,, Ahk_ID %lvhwnd%
	Return ( ErrorLevel & 0xFFFFFFFF ) + 1, ErrorLevel := oel
}
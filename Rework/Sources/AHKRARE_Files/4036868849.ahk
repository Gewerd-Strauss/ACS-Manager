LV_SubitemHitTest(HLV) {																								;-- get's clicked column in listview
	; To run this with AHK_Basic change all DllCall types "Ptr" to "UInt", please.
	; HLV - ListView's HWND
	Static LVM_SUBITEMHITTEST := 0x1039
	VarSetCapacity(POINT, 8, 0)
	; Get the current cursor position in screen coordinates
	DllCall("User32.dll\GetCursorPos", "Ptr", &POINT)
	; Convert them to client coordinates related to the ListView
	DllCall("User32.dll\ScreenToClient", "Ptr", HLV, "Ptr", &POINT)
	; Create a LVHITTESTINFO structure (see below)
	VarSetCapacity(LVHITTESTINFO, 24, 0)
	; Store the relative mouse coordinates
	NumPut(NumGet(POINT, 0, "Int"), LVHITTESTINFO, 0, "Int")
	NumPut(NumGet(POINT, 4, "Int"), LVHITTESTINFO, 4, "Int")
	; Send a LVM_SUBITEMHITTEST to the ListView
	SendMessage, LVM_SUBITEMHITTEST, 0, &LVHITTESTINFO, , ahk_id %HLV%
	; If no item was found on this position, the return value is -1
	If (ErrorLevel = -1)
	Return 0
	; Get the corresponding subitem (column)
	Subitem := NumGet(LVHITTESTINFO, 16, "Int") + 1
Return Subitem
}
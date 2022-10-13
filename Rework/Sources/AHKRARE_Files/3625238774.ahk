LV_GetCount(hLV) {																											;-- get current count of notes in from any listview

	;https://autohotkey.com/boards/viewtopic.php?t=26317
	;hLV - Listview handle
	c := DllCall("SendMessage", "uint", hLV, "uint", 0x18B) ; LB_GETCOUNT
return c
}
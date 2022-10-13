LV_SetColOrderLocal(hCtl, oList, vSep:="") {																	;-- pass listview hWnd (not listview header hWnd)

	;for local controls only
	if !IsObject(oList)
	oList := StrSplit(oList, vSep)
	if !(vCountCol := oList.Length())
	return
	VarSetCapacity(vData, vCountCol*4)
	for _, vValue in oList
	NumPut(vValue-1, &vData, A_Index*4-4, "Int")
	SendMessage(0x103A, vCountCol, &vArray,, "ahk_id " hCtl) ;LVM_SETCOLUMNORDERARRAY := 0x103A
}
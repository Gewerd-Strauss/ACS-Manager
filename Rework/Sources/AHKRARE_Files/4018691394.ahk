LV_SetSI(hList, iItem, iSubItem, iImage) {                                                                       	;-- set icon for row "subItem" within Listview
	VarSetCapacity(LVITEM, 60, 0)
	LVM_SETITEM := 0x1006 , mask := 2   ; LVIF_IMAGE := 0x2
	iItem-- , iSubItem-- , iImage--		; Note first column (iSubItem) is #ZERO, hence adjustment
	NumPut(mask, LVITEM, 0, "UInt")
	NumPut(iItem, LVITEM, 4, "Int")
	NumPut(iSubItem, LVITEM, 8, "Int")
	NumPut(iImage, LVITEM, 28, "Int")
	result := DllCall("SendMessageA", UInt, hList, UInt, LVM_SETITEM, UInt, 0, UInt, &LVITEM)
	return result
}
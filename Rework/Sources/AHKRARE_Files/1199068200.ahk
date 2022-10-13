LV_EX_FindString(HLV, Str, Start := 0, Partial := False) {													;-- find an item in any listview , function works with ANSI and UNICODE (tested)
	; LVM_FINDITEM -> http://msdn.microsoft.com/en-us/library/bb774903(v=vs.85).aspx
	Static LVM_FINDITEM := A_IsUnicode ? 0x1053 : 0x100D ; LVM_FINDITEMW : LVM_FINDITEMA
	Static LVFISize := 40
	VarSetCapacity(LVFI, LVFISize, 0) ; LVFINDINFO
	Flags := 0x0002 ; LVFI_STRING
	If (Partial)
	Flags |= 0x0008 ; LVFI_PARTIAL
	NumPut(Flags, LVFI, 0, "UInt")
	NumPut(&Str,  LVFI, A_PtrSize, "Ptr")
	SendMessage, % LVM_FINDITEM, % (Start - 1), % &LVFI, , % "ahk_id " . HLV
Return (ErrorLevel > 0x7FFFFFFF ? 0 : ErrorLevel + 1)
}
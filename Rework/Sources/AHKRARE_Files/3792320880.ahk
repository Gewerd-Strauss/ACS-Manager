LV_EX_SetTileViewLines(HLV, Lines, tileX := "", tileY := "") {                                        	;-- sets the maximum number of additional text lines in each tile, not counting the title
	; LVM_GETTILEVIEWINFO = 0x10A3 -> http://msdn.microsoft.com/en-us/library/bb761083(v=vs.85).aspx
	; LVM_SETTILEVIEWINFO = 0x10A2 -> http://msdn.microsoft.com/en-us/library/bb761212(v=vs.85).aspx

	Static SizeLVTVI := 40
	Static offSize := 12
	Static OffLines := 20
	Static LVTVIM_TILESIZE := 0x1
	Static LVTVIM_COLUMNS := 0x2
	Static LVTVIF_AUTOSIZE := 0x0, LVTVIF_FIXEDWIDTH := 0x1, LVTVIF_FIXEDHEIGHT := 0x2, LVTVIF_FIXEDSIZE := 0x3
	Mask := LVTVIM_COLUMNS | (tileX || tileY ? LVTVIM_TILESIZE : 0)
	If (tileX && tileY)
		flag := LVTVIF_FIXEDSIZE
	Else If (tileX && !tileY)
		flag := LVTVIF_FIXEDWIDTH
	Else If (!tileX && tileY)
		flag := LVTVIF_FIXEDHEIGHT
	Else
		flag := LVTVIF_AUTOSIZE
	; If (Lines > 0)
	; Lines++
	VarSetCapacity(LVTVI, SizeLVTVI, 0)     ; LVTILEVIEWINFO
	NumPut(SizeLVTVI, LVTVI, 0, "UInt")     ; cbSize
	NumPut(Mask, LVTVI, 4, "UInt")    ; dwMask = LVTVIM_TILESIZE | LVTVIM_COLUMNS
	NumPut(flag, LVTVI, 8, "UInt")       ; dwMask
	if (tileX)
		NumPut(tileX, LVTVI, 12, "Int")       ; sizeTile.cx
	if (tileY)
		NumPut(tileY, LVTVI, 16, "Int")       ; sizeTile.cx
	NumPut(Lines, LVTVI, OffLines, "Int") ; c_lines: max lines below first line
	SendMessage, 0x10A2, 0, % &LVTVI, , % "ahk_id " . HLV ; LVM_SETTILEVIEWINFO
	Return ErrorLevel
}
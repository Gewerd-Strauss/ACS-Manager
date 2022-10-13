LV_Select(r:=1, Control:="", WinTitle:="") {																		;-- select/deselect 1 to all rows of a listview

	; Modified from http://www.autohotkey.com/board/topic/54752-listview-select-alldeselect-all/?p=343662
	; Examples: LVSel(1 , "SysListView321", "Win Title")   ; Select row 1. (or use +1)
	;           LVSel(-1, "SysListView321", "Win Title")   ; Deselect row 1
	;           LVSel(+0, "SysListView321", "Win Title")   ; Select all
	;           LVSel(-0, "SysListView321", "Win Title")   ; Deselect all
	;           LVSel(+0,                 , "ahk_id " HLV) ; Use listview's hwnd

	VarSetCapacity(LVITEM, 4*15, 0) ;Do *13 if you're not on Vista or Win 7 (see MSDN)

	state := InStr(r, "-") ? 0x00000000 : 0x00000002
	NumPut(0x00000008, LVITEM, 4*0) ;mask = LVIF_STATE
	NumPut(state,      LVITEM, 4*3) ;state = <second LSB must be 1>
	NumPut(0x0002,     LVITEM, 4*4) ;stateMask = LVIS_SELECTED

	;LVM_SETITEMSTATE = LVM_FIRST + 43
	r := RegExReplace(r, "\D") - 1
	SendMessage, 0x1000 + 43, r, &LVITEM, %Control%, %WinTitle%
}
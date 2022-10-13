LV_Notification(WParam, LParam, msg, hwnd) {                                                         	;-- easy function for showing notifications by hovering over a listview

	;http://ahkscript.org/germans/forums/viewtopic.php?t=8225&sid=35ddff584bfe8d4e4c44a0789b388655
	; this line for autoexec: OnMessage(WM_NOTIFY, "Notification")

	Global lvx, toggle, HLV1, HLV2
	Static LVN_ITEMCHANGING := -100
	Static LVIS_STATEIMAGEMASK := 0xF000 ; checked

	;---THX an "ich" für diese Routine, um check/-uncheck zu verhindern
	If (toggle = 0) ;0, dann keinen check/-Uncheck zulassen
	If (NumGet(LParam+0) = HLV1) OR (NumGet(LParam+0) = HLV2) ; NMHDR -> hwndFrom
	If (NumGet(LParam+0, 8, "Int") = LVN_ITEMCHANGING) ; NMHDR -> code
	If (NumGet(LParam+0, 24) & LVIS_STATEIMAGEMASK) ; NMLISTVIEW -> uChanged
		Return True ; True verhindert die Änderung

	;---from Titan für Color-Rows
	If (NumGet(LParam + 0) == NumGet(lvx))
		Return, LVX_Notify(WParam, LParam, msg)

	;---verhindert das Ändern der Spaltenbreite
	If (Code:=(~NumGet(LParam+0,8))+1)
		Return,Code=306||Code=326 ? True:""
}
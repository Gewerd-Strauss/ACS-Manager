LB_SetItemHeight(HListBox, NewHeight) {																	;-- Listbox function
	; https://github.com/altbdoor/ahk-hs-chara/blob/master/utility.ahk
	Static LB_SETITEMHEIGHT := 0x01A0
	SendMessage, %LB_SETITEMHEIGHT%, 0, %NewHeight%, , ahk_id %HListBox%
	WinSet, Redraw, , ahk_id %HListBox%
	Return ErrorLevel
}
LB_GetItemHeight(HListBox) {																						;-- Listbox function
	; https://github.com/altbdoor/ahk-hs-chara/blob/master/utility.ahk
	Static LB_GETITEMHEIGHT := 0x01A1
	SendMessage, %LB_GETITEMHEIGHT%, 0, 0, , ahk_id %HListBox%
	Return ErrorLevel
}
LB_AdjustItemHeight(HListBox, Adjust) {																	;-- Listbox function
	; https://autohotkey.com/board/topic/89793-set-height-of-listbox-rows/
	; https://github.com/altbdoor/ahk-hs-chara/blob/master/utility.ahk
	Return LB_SetItemHeight(HListBox, LB_GetItemHeight(HListBox) + Adjust)
}
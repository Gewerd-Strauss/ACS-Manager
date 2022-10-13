Edit_TextIsSelected(Control="", WinTitle="") {												;-- returns bool if text is selected in an edit control
	; Returns true if text is selected, otherwise false.
;
	Edit_Standard_Params(Control, WinTitle)
	return Edit_GetSelection(start, end, Control, WinTitle) and (start!=end)
}
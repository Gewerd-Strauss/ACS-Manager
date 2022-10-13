Edit_GetSelection(ByRef start, ByRef end, Control="", WinTitle="") {				;-- get selected text in an edit control
	; Gets the start and end offset of the current selection.
;
	Edit_Standard_Params(Control, WinTitle)
	VarSetCapacity(start, 4), VarSetCapacity(end, 4)
	SendMessage, 0xB0, &
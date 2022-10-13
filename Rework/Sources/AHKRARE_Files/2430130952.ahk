Edit_DeleteLine(line=0, Control="", WinTitle="") {											;-- delete one line in an edit control
	; Deletes a line of text.
	;
	; line:     One-based line number, or 0 to delete current line.
	;

	Edit_Standard_Params(Control, WinTitle)
	; Select the line.
	if (Edit_SelectLine(line, true, Control, WinTitle))
	{   ; Delete it.
		ControlSend, %Control%, {Delete}, %WinTitle%
		return true
	}
	return false
}
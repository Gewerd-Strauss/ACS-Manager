Edit_Select(start=0, end=-1, Control="", WinTitle="") {									;-- selects text inside in an edit control
	; Selects text in a text box, given absolute character positions (starting at 0.)
	;
	; start:    Starting character offset, or -1 to deselect.
	; end:      Ending character offset, or -1 for "end of text."
	;

	Edit_Standard_Params(Control, WinTitle)
	SendMessage, 0xB1, start, end, %Control%, %WinTitle%  ; EM_SETSEL
	return (ErrorLevel != "FAIL")
}
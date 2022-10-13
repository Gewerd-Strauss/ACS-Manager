Edit_SelectLine(line=0, include_newline=false, Control="", WinTitle="") {		;-- selects one line in an edit control
		; Selects a line of text.
	;
	; line:             One-based line number, or 0 to select the current line.
	; include_newline:  Whether to also select the line terminator (`r`n).
	;

	Edit_Standard_Params(Control, WinTitle)

	ControlGet, hwnd, Hwnd,, %Control%, %WinTitle%
	if (!WinExist("ahk_id " hwnd))
		return false

	if (line<1)
		ControlGet, line, CurrentLine

	SendMessage, 0xBB, line-1, 0  ; EM_LINEINDEX
	offset := ErrorLevel

	SendMessage, 0xC1, offset, 0  ; EM_LINELENGTH
	lineLen := ErrorLevel

	if (include_newline) {
		WinGetClass, class
		lineLen += (class="Edit") ? 2 : 1 ; `r`n : `n
	}

	; Select the line.
	SendMessage, 0xB1, offset, offset+lineLen  ; EM_SETSEL
	return (ErrorLevel != "FAIL")
}
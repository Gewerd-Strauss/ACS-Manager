Edit_Standard_Params(ByRef Control, ByRef WinTitle) {  								;-- these are helper functions to use with edit controls
	if (Control = "A" && WinTitle="") { ; Control is "A", use focused control.
		ControlGetFocus, Control, A
		WinTitle = A
	} else if (Control+0!="" && WinTitle="") {  ; Control is numeric, assume its a ahk_id.
		WinTitle := "ahk_id " . Control

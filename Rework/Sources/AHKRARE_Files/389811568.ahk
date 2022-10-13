ControlGetClassNN( control="", Window="", Text="", ExWin="", ExText="" ) {	    	;-- different method is used here in compare to the already existing functions in this collection

	WinGet, cl, ControlList, % Window, % Text, % ExWin, % ExText
	WinGet, hl, ControlListHWND, % Window, % Text, % ExWin, % ExText
	ControlGet, ch, hwnd,, % control, % Window, % Text, % ExWin, % ExText
	If ErrorLevel

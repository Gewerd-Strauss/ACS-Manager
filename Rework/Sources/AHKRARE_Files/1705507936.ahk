Ask_and_SetbackFocus(AskTitle, AskText) {				    		 			;-- by opening a msgbox you lost focus and caret pos in any editor - this func will restore the previous positions of the caret



	CoordMode, Caret, Window
	CoordMode, Mouse, Window
	;xcaret:= A_CaretX, ycaret:= A_CaretY
	active_WId:=WinExist("A")
	active_CId:= GetFocusedControl("Hwnd")
	;user input - change this line to what you like
	MsgBox, 4, %AskTitle%, %AskText%
	BlockInput, On
		WinActivate, ahk_id %active_WId%
			WinWaitActive, ahk_id %active_WId%, 4
	ControlFocus, , ahk_id %active_CId%
		;this part can be used, but with SciTE it's only needed to set the focus back to the editor window
		;Pause
		;DllCall("SetCursorPos", int, xcaret, int, ycaret)
		;SetControlDelay -1
		;ControlClick,, ahk_id %active_WId%,, Left, 1, x%xcaret% y%ycaret%
		;Click, %xcaret%, %ycaret%
	BlockInput, Off
	IfMsgBox, Yes
		return 1
	IfMsgBox, No
		return 0
}
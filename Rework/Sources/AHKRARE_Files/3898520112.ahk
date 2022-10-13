WinSaveCheckboxes(hWin) {                                                                                     	;-- save the status of checkboxes in other apps
	cArrT1:= cArrT2:= [], idx:=0
	oControls1:= Object()
	oControls2:= Object()

	WinGet, cClasses, ControlList, % "ahk_id " hWin
	WinGet, cHwnds, ControlListHwnd, % "ahk_id " hWin

	oControls1:= KeyValueObjectFromLists(cClasses, cHwnds, "`n", "Button", "[A-Za-z]+", "", "")

	For key, val in oControls1
	{
			If InStr(GetButtonType(val), "Checkbox") {
					status:= ControlGet("checked",,, "ahk_id " . val)
					oControls2[(key)]:= status
					idx++
			}
	}

	If !idx
		return 0

return oControls2
}
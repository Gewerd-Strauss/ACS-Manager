WM_WINDOWPOSCHANGING(wParam, lParam) {                           	;-- second examples of handling a WM_WINDOWPOSCHANGING

	global

	If (A_Gui = 1 && !(NumGet(lParam+24) & 0x2))
	{
		x := NumGet(lParam+8),  y := NumGet(lParam+12)

		Result := DllCall("SetWindowPos", "UInt", Gui2, "UInt", Gui1, "Int", x-50, "Int", y-50, "Int", "", "Int", "", "Int", 0x01)
	}
	SetTimer, OnTop, 10

	Result := DllCall("SetWindowPos", "UInt", Gui1, "UInt", Gui2, "Int", "", "Int", "", "Int", "", "Int", "", "Int", 0x03)
	;Tooltip, %Result%
	Return
}
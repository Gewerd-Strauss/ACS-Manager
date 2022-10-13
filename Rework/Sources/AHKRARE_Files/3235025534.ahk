HWNDToClassNN(hwnd) {                                                                                      	;-- a different approach to get classNN from handle
	win := DllCall("GetParent", "PTR", hwnd, "PTR")
	WinGet ctrlList, ControlList, ahk_id %win%
	; Built an array indexing the control names by their hwnd
	Loop Parse, ctrlList, `n
	{
		ControlGet hwnd1, Hwnd, , %A_LoopField%, ahk_id %win%
		if(hwnd1=hwnd)
			return A_LoopField
	}
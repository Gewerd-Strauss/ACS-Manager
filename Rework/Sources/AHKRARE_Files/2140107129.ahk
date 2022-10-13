PostMessageUnderMouse(Message, wParam = 0, lParam=0) {									;-- Post a message to the window underneath the mouse cursor, can be used to do things involving the mouse scroll wheel
	oldCoordMode:= A_CoordModeMouse
	CoordMode, Mouse, Screen
	MouseGetPos X, Y, , , 2
	hWnd := DllCall("WindowFromPoint", "int", X , "int", Y)
	PostMessage %Message%, %wParam%, %lParam%, , ahk_id %hWnd%
	CoordMode, Mouse, %oldCoordMode%
}
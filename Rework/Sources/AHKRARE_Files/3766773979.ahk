WinSetPlacement(hwnd, x="",y="",w="",h="",state="") {											;-- Sets window position using workspace coordinates (-> no taskbar)

	WinGetPlacement(hwnd, x1, y1, w1, h1, state1)
	if (x = "")
		x := x1
	if (y = "")
		y := y1
	if (w = "")
		w := w1
	if (h = "")
		h := h1
	if (state = "")
		state := state1
	VarSetCapacity(wp, 44), NumPut(44, wp)
	if (state = 6)
		NumPut(7, wp, 8) ;SW_SHOWMINNOACTIVE
	else if (state = 1)
		NumPut(4, wp, 8) ;SW_SHOWNOACTIVATE
	else if (state = 3)
		NumPut(3, wp, 8) ;SW_SHOWMAXIMIZED and/or SW_MAXIMIZE
	else
		NumPut(state, wp, 8)
	NumPut(x, wp, 28, "Int")
    NumPut(y, wp, 32, "Int")
    NumPut(x+w, wp, 36, "Int")
    NumPut(y+h, wp, 40, "Int")
	DllCall("SetWindowPlacement", "Ptr", hwnd, "Ptr", &wp)
}
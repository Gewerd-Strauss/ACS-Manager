GetParent(hWnd) {																										;-- get parent win handle of a window

	return DllCall("GetParent", "Ptr", hWnd, "Ptr")
}
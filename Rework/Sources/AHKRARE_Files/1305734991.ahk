WinInsertAfter(hwnd, afterHwnd) {																				;-- insert a window after a specific window handle
	return DllCall("SetWindowPos", "UINT", hwnd, "UINT", afterHwnd, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
}
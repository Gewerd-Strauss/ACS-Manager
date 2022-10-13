WinGetMinMaxState(hwnd) {																						;-- get state if window ist maximized or minimized

	zoomed := DllCall("IsZoomed", "UInt", hwnd)
	; Check if minimized
	iconic := DllCall("IsIconic", "UInt", hwnd)

	return (zoomed>iconic) ? "z":"i"
}
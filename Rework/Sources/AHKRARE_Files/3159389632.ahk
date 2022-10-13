WM_SETCURSOR(wParam, lParam) { 																			;-- Prevent "sizing arrow" cursor when hovering over window border

	static HARROW := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32512, "UPtr")

	HTCODE := lParam & 0xFFFF
	if (HTCODE > 9) && (HTCODE < 19) { ; cursor is on a border
		DllCall("SetCursor", "Ptr", HARROW) ; show arrow cursor
		return true ; prevent further processing
	}
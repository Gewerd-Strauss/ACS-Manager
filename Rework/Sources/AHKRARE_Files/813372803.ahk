GetLastActivePopup(hwnd) {																						;-- passes the handle of the last active pop-up window of a parent window
	return DLLCall("GetLastActivePopup", "uint", hwnd)
}
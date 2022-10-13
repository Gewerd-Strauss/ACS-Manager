LockCursorToPrimaryMonitor(lock = true) {                                                           	;-- prevents the cursor from leaving the primary monitor
	; Get mouse position on screen
	VarSetCapacity( pt, 8, 0 )
	DllCall("GetCursorPos", "Ptr", &pt)
	x := NumGet(pt, 0, "Int")

	; If the cursor already on the second monitor, then leave it there.
	if (x > A_ScreenWidth) {
		return
	}

	; ClipCursor -- https://msdn.microsoft.com/en-us/library/windows/desktop/ms648383(v=vs.85).aspx
	if (lock) {
		VarSetCapacity(rect, 16, 0)
		NumPut(A_ScreenWidth, rect, 8)
		NumPut(A_ScreenHeight,
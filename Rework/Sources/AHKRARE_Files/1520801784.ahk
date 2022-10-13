GetProcessName(hwnd) {																					;-- Gets the process name from a window handle.

	WinGet, ProcessName, processname, ahk_id %hwnd%
	return ProcessName
}
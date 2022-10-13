Win32_Terminate(win) {																								;--
	WinGet, win_pid, PID, ahk_id %win%
	handle := DllCall("Kernel32\OpenProcess", UInt, 0x0001, UInt, 0, UInt, win_pid)
	if (!handle)
		return false
	result := DllCall("Kernel32\TerminateProcess", 
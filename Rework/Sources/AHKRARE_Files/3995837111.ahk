Win32_TaskKill(win) {																									;--
	WinGet, win_pid, PID, ahk_id %win%
	cmdline := "taskkill /pid " . win_pid . " /f"
	Run, %cmdline%,, Hide UseErrorLevel
	if (ErrorLevel != 0 or !IsClosed(win, 5))
		return false
	return true
}
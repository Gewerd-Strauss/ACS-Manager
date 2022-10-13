WinWaitProgress(Progress = 100, WinTitle = "", WinText = "", Timeout = "") {     	;-- Waits for the progress bar on a window to reach (>=) a given value (a Lexikos function)
	began_at := A_TickCount
	While (n := ControlGetProgress("msctls_progress321", WinTitle, WinText)) != "FAIL"
		&& n < Progress && (Timeout = "" || (A_TickCount-began_at)/1000 < Timeout)
		Sleep 100
	return (ErrorLevel + 0) >= Progress
}
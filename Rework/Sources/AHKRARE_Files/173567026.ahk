TryKillWin(win) {																											;--
	static funcs := ["Win32_SendMessage", "Win32_TaskKill", "Win32_Terminate"]

	if (IsClosed(win, 0.5)) {
		IdleGui("Window is already closed", "", 3, true)
		return
	}

	for i, v in funcs {
		IdleGui("Trying " . v . "...", "Closing...", 10, false)
		if (%v%(win)) {
			IdleGuiClose()
			return true
		}
	}
	return false
}
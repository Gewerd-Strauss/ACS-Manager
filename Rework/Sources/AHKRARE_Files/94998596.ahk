pauseSuspendScript(ScriptTitle, suspendHotkeys := False, pauseScript := False) {	;-- function to suspend/pause another script
	prevDetectWindows := A_DetectHiddenWindows
	prevMatchMode := A_TitleMatchMode
	DetectHiddenWindows, On
	SetTitleMatchMode, 2
	if (script_id := WinExist(ScriptTitle " ahk_class AutoHotkey"))
	{
		; Force the script to update its Pause/Suspend checkmarks.
		SendMessage, 0x211,,,, ahk_id %script_id%  ; WM_ENTERMENULOOP
		SendMessage, 0x212,,,, ahk_id %script_id%  ; WM_EXITMENULOOP
		; Get script status from its main menu.
		mainMenu := DllCall("GetMenu", "uint", script_id)
		fileMenu := DllCall("GetSubMenu", "uint", mainMenu, "int", 0)
		isPaused := DllCall("GetMenuState", "uint", fileMenu, "uint", 4, "uint", 0x400) >> 3 & 1
		isSuspended := DllCall("GetMenuState", "uint", fileMenu, "uint", 5, "uint", 0x400) >> 3 & 1
		DllCall("CloseHandle", "uint", fileMenu)
		DllCall("CloseHandle", "uint", mainMenu)
		if (suspendHotkeys && !isSuspended) || (!suspendHotkeys && isSuspended)
			PostMessage, 0x111, 65305, 1,,  ahk_id %script_id% ; this toggles the current suspend state.
		if (pauseScript && !isPaused) || (!pauseScript && isPaused)
			PostMessage, 0x111, 65403,,,  ahk_id %script_id% ; this toggles the current pause state.
	}
	DetectHiddenWindows, %prevDetectWindows%
	SetTitleMatchMode, %prevMatchMode%
	return script_id
}
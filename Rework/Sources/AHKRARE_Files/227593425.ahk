ScriptExist(scriptname) {                                                                                     	;-- true oder false if Script is running or not

	dtWin:= A_DetectHiddenWindows
	DetectHiddenWindows, On							;this must be set to On to find scripts without a gui

	WinGet, hwnd, List, ahk_class AutoHotkey

	Loop, %hwnd%
	{
			ID := hwnd%A_Index%
			WinGetTitle, Titel, ahk_id %ID%
			WinGet, PID, PID, ahk_id %ID%
			SplitPath, Titel, runningAHK
			If InStr(runningAHK, tostartAHK)
							return 1
	}

	DetectHiddenWindows, % dtWin

return 0
}
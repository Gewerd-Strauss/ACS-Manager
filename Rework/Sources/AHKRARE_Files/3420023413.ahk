ObjectNameChange(hWinEventHook, event, hwnd,                      	;-- titlebar hook to detect when title changes, (Lexikos' code)
idObject, idChild, thread, time) {

		; a Lexikos function
	; If the object is a window (OBJID_WINDOW), is not hidden, and is not a child window,
	if (idObject=0) && WinExist("ahk_id " hwnd) && DllCall("GetAncestor","uint",hwnd,"uint",1)=DllCall("GetDesktopWindow")
		If(newtitle := Win_%hwnd%)!=""{
			WinGetTitle, title, ahk_id %hwnd%
			If(title != newtitle)
				WinSetTitle, ahk_id %hwnd%,, %newtitle%
		}
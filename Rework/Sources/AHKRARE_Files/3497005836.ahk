AttachToolWindow(hParent, GUINumber, AutoClose) {												;-- Attaches a window as a tool window to another window from a different process.
	global ToolWindows
	outputdebug AttachToolWindow %GUINumber% to %hParent%
	if (!IsObject(ToolWindows))
		ToolWindows := Object()
	if (!WinExist("ahk_id " hParent))
		return false
	Gui %GUINumber%: +LastFoundExist
	if (!(hGui := WinExist()))
		return false
	;SetWindowLongPtr is defined as SetWindowLong in x86
	if (A_PtrSize = 4)
		DllCall("SetWindowLong", "Ptr", hGui, "int", -8, "PTR", hParent) ;This line actually sets the owner behavior
	else
		DllCall("SetWindowLongPtr", "Ptr", hGui, "int", -8, "PTR", hParent) ;This line actually sets the owner behavior
	ToolWindows.Insert(Object("hParent", hParent, "hGui", hGui,"AutoClose", AutoClose))
	Gui %GUINumber%: Show, NoActivate
	return true
}
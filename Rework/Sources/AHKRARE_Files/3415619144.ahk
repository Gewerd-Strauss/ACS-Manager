DeAttachToolWindow(GUINumber) {																			;-- removes the attached ToolWindow

	global ToolWindows
	Gui %GUINumber%: +LastFoundExist
	if (!(hGui := WinExist()))
		return false
	Loop % ToolWindows.MaxIndex()
	{
		if (ToolWindows[A_Index].hGui = hGui)
		{
			;SetWindowLongPtr is defined as SetWindowLong in x86
			if (A_PtrSize = 4)
				DllCall("SetWindowLong", "Ptr", hGui, "int", -8, "PTR", 0) ;Remove tool window behavior
			else
				DllCall("SetWindowLongPtr", "Ptr", hGui, "int", -8, "PTR", 0) ;Remove tool window behavior
			DllCall("SetWindowLongPtr", "Ptr", hGui, "int", -8, "PTR", 0)
			ToolWindows.Remove(A_Index)
			break
		}
	}
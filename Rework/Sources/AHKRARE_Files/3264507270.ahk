EnumChildWindow(hwnd, lParam) { 																			;-- sub function of FindChildWindow

	global ChildHwnds
	global SearchChildTitle, SearchChildClass, active_id

	WinGetTitle, childtitle, ahk_id %hwnd%
	childclassNN:= GetClassNN(hwnd, active_id)

	If (InStr(childtitle, SearchChildTitle) and InStr(childclassNN, SearchChildClass))
	{
			ChildHwnds.= hwnd . "`;"
	}

    return true  ; Tell EnumWindows() to continue until all windows have been enumerated.
}
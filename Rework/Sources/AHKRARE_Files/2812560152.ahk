SetWindowTheme(handle) {																						;-- set Windows UI Theme by window handle

	; https://github.com/jNizM/ahk_pi-hole/blob/master/src/pi-hole.ahk
	 ; https://msdn.microsoft.com/en-us/library/bb759827(v=vs.85).aspx
	global WINVER

	if (WINVER >= 0x0600) {
		VarSetCapacity(ClassName, 1024, 0)
		if (DllCall("user32\GetClassName", "ptr", handle, "str", ClassName, "int", 512, "int"))
			if (ClassName = "SysListView32") || (ClassName = "SysTreeView32")
				if !(DllCall("uxtheme\SetWindowTheme", "ptr", handle, "wstr", "Explorer", "ptr", 0))
					return true
	}
	return false
}
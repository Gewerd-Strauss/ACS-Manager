GetClassNN_EnumChildProc(hwnd, lparam) {                                                         	;-- sub function of FindChildWindow
	static N
	global _GetClassNN
	WinGetClass, Class, ahk_id %hwnd%
	if _GetClassNN.Class == Class
		N++
	return _GetClassNN.Hwnd==hwnd? (0, _GetClassNN.ClassNN:=_GetClassNN.Class N, N:=0):1
}
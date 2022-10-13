IsWindow(hWnd*) {																										;-- sub of SetTaskbarProgress, different approach to IsWindow in gui + window - get/find section
	if !hWnd.MaxIndex()
		return DllCall("User32.dll\GetForegroundWindow")
	return i := DllCall("User32.dll\IsWindow", "Ptr", hWnd[1] )
		, ErrorLevel := !i
}
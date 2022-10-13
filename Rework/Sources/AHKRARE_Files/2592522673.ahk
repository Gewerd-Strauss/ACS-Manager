GetForegroundWindow() {																							;-- returns handle of the foreground window
	return DllCall("GetForeGroundWindow", "Ptr")
}
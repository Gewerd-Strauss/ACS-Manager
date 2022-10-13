GetWindow(hWnd,uCmd) {																							;-- DllCall wrapper for GetWindow function

	return DllCall( "GetWindow", "Ptr", hWnd, "
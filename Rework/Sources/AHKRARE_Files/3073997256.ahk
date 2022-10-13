ShowWindow(hWnd, nCmdShow := 1) {	                                                                	;-- uses a DllCall to show a window
    DllCall("ShowWindow", "Ptr", hWnd, "Int", nCmdShow)
}
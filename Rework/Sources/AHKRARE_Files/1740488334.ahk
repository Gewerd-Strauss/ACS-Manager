WipeSurface(hwnd) {                                                                                              	;-- subfunction for CreateSurface
	DllCall("InvalidateRect", UInt, hwnd, UInt, 0, Int, 1)
    DllCall("UpdateWindow", UInt, hwnd)
}
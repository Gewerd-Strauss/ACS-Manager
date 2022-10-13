EndDraw(hdc) {                                                                                                    	;-- subfunction for CreateSurface
	global DrawSurface_Hwnd
	DllCall("ReleaseDC", Int, DrawSurface_Hwnd, Int, hdc)
}
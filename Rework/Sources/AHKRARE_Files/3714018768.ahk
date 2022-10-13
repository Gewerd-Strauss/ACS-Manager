StartDraw(wipe := true) {                                                                                        	;-- subfunction for CreateSurface

	global DrawSurface_Hwnd

	if (wipe)
		WipeSurface(DrawSurface_Hwnd)

    HDC := DllCall("GetDC", Int, DrawSurface_Hwnd)

    return HDC
}
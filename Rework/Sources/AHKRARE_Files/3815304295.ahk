CaptureScreen(aRect = 0,  sFile = "", bCursor = false, nQuality = "") {                	;-- screenshot function 4 - orginally from CaptureScreen.ahk

	/*			DESCRIPTIONS OF FUNCTION CaptureScreen()

	CaptureScreen(aRect, sFileTo, bCursor, nQuality)

	Author             	:	RaptorX
	Link                  	:	https://github.com/RaptorX/AHK-ToolKit/blob/master/lib/sc.ahk
	Parameter        	:	1) If the optional parameter bCursor is True, captures the cursor too.
                     	        	2) If the optional parameter sFileTo is 0, set the image to Clipboard.
										 If it is omitted or "", saves to screen.bmp in the script folder,
										 otherwise to sFileTo which can be BMP/JPG/PNG/GIF/TIF.
                     	        	3) The optional parameter nQuality is applicable only when sFileTo is JPG.
										 Set it to the desired quality level of the resulting JPG, an integer between 0 - 100.
                     	        	4) If aRect is 0/1/2/3, captures the entire desktop/active window/active client area/active monitor.
                     	        	5) aRect can be comma delimited sequence of coordinates, e.g., "Left, Top,
										Right, Bottom" or "Left, Top, Right, Bottom, Width_Zoomed, Height_Zoomed".
										In this case, only that portion of the rectangle will be captured. Additionally,
										in the latter case, zoomed to the new width/height, Width_Zoomed/Height_Zoomed.
	related functions	:	can be found in the following libraries
									Unicode4Ansi          	-		CoHelper.ahk
									Ansi4Unicode          	-		CoHelper.ahk
									Zoomer                    	-		this library or ScreenCapture.ahk
	                                CreateDIBSection    	-		Gdip_all.ahk
                                    SaveHBITMAPToFile	-		this library or ScreenCapture.ahk
	                                SetClipboardData    	-		Gdip_all.ahk
									Convert                    	-		this library
	*/
	If (!aRect) {
		SysGet, nL, 76
		SysGet, nT, 77
		SysGet, nW, 78
		SysGet, nH, 79
	}
	Else If (aRect = 1)
		WinGetPos, nL, nT, nW, nH, A
	Else If (aRect = 2) 	{
		WinGet, hWnd, ID, A
		VarSetCapacity(rt, 16, 0)
		DllCall("GetClientRect" , "Uint", hWnd, "Uint", &rt)
		DllCall("ClientToScreen", "Uint", hWnd, "Uint", &rt)
		nL := NumGet(rt, 0, "int")
		nT := NumGet(rt, 4, "int")
		nW := NumGet(rt, 8)
		nH := NumGet(rt,12)
	} Else If (aRect = 3) 	{
		VarSetCapacity(mi, 40, 0)
		DllCall("GetCursorPos", "int64P", pt)
		DllCall("GetMonitorInfo", "Uint", DllCall("MonitorFromPoint", "int64", pt, "Uint", 2), "Uint", NumPut(40,mi)-4)
		nL := NumGet(mi, 4, "int")
		nT := NumGet(mi, 8, "int")
		nW := NumGet(mi,12, "int") - nL
		nH := NumGet(mi,16, "int") - nT
	} Else If (isObject(aRect)) {
		nL := aRect.Left, nT := aRect.Top, nW := aRect.Right - aRect.Left, nH := aRect.Bottom - aRect.Top
		znW := aRect.ZoomW, znH := aRect.ZoomH
	} Else {
		StringSplit, rt, aRect, `,, %A_Space%%A_Tab%
		nL := rt1, nT := rt2, nW := rt3 - rt1, nH := rt4 - rt2
		znW := rt5, znH := rt6
	}

	mDC := DllCall("CreateCompatibleDC", "Uint", 0)
	hBM := CreateDIBSection(mDC, nW, nH)
	oBM := DllCall("SelectObject", "Uint", mDC, "Uint", hBM)
	hDC := DllCall("GetDC", "Uint", 0)
	DllCall("BitBlt", "Uint", mDC, "int", 0, "int", 0, "int", nW, "int", nH, "Uint", hDC, "int", nL, "int", nT, "Uint", 0x40000000 | 0x00CC0020)
	DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
	If	bCursor
		CaptureCursor(mDC, nL, nT)
	DllCall("SelectObject", "Uint", mDC, "Uint", oBM)
	DllCall("DeleteDC", "Uint", mDC)
	If	znW && znH
		hBM := Zoomer(hBM, nW, nH, znW, znH)
	If	sFile = 0
		SetClipboardData(hBM)
	Else Convert(hBM, sFile, nQuality), DllCall("DeleteObject", "Uint", hBM)
}
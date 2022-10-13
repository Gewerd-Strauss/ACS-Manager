MeasureText(Str, FontOpts = "", FontName = "") {                                                      	;--  Measures the single-line width and height of the passed text
	Static DT_FLAGS := 0x0520 ; DT_SINGLELINE = 0x20, DT_NOCLIP = 0x0100, DT_CALCRECT = 0x0400
	Static WM_GETFONT := 0x31

	Size := {}
	Gui, New
	If (FontOpts <> "") || (FontName <> "")
		Gui, Font, %FontOpts%, %FontName%
	Gui, Add, Text, hwndHWND
	SendMessage, WM_GETFONT, 0, 0, , ahk_id %HWND%
	HFONT := ErrorLevel
	HDC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
	DllCall("Gdi32.dll\SelectObject", "Ptr", HDC, "Ptr", HFONT)
	VarSetCapacity(RECT, 16, 0)
	DllCall("User32.dll\DrawText", "Ptr", HDC, "Str", Str, "Int", -1, "Ptr", &RECT, "UInt", DT_FLAGS)
	DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", HDC)
	Gui, Destroy
	Size.W := NumGet(RECT,  8, "Int")
	Size.H := NumGet(RECT, 12, "Int")
	Return Size
}
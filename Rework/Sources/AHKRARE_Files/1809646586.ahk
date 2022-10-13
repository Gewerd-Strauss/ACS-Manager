getSelectionCoords(ByRef x_start, ByRef x_end, ByRef y_start, ByRef y_end) {    	;-- creates a click-and-drag selection box to specify an area

	/*			EXAMPLE

				;hotkey to activate OCR
				!q:: ;press ALT Q
				getSelectionCoords(x_start, x_end, y_start, y_end)
				MsgBox, In area :: x_start: %x_start%, y_start: %y_start% --> x_end: %x_end%, y_end: %y_end%
				return

			Esc:: ExitApp

	*/

	;Mask Screen
	Gui, Color, FFFFFF
	Gui +LastFound
	WinSet, Transparent, 50
	Gui, -Caption
	Gui, +AlwaysOnTop
	Gui, Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%,"AutoHotkeySnapshotApp"

	;Drag Mouse
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	WinGet, hw_frame_m,ID,"AutoHotkeySnapshotApp"
	hdc_frame_m := DllCall( "GetDC", "uint", hw_frame_m)
	KeyWait, LButton, D
	MouseGetPos, scan_x_start, scan_y_start
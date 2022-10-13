FrameShadow(HGui) {																					            	;-- FrameShadow(): Drop Shadow On Borderless Window, (DWM STYLE)

	;--https://autohotkey.com/boards/viewtopic.php?t=29117

	/*
	Gui, +HwndHGui -Caption - Example
	FrameShadow(HGui)
	Gui, Add, Button, x10 y130 w100 h30, Minimize
	Gui, Add, Button, x365 y130 w100 h30, Exit
	Gui, Add, GroupBox, x10 y10 w455 h110, GroupBox
	Gui, Add, Edit, x20 y30 w435 h80 +Multi, Edit
	Gui, Show, Center w475 h166, Frame Shadow Test
	*/

	DllCall("dwmapi\DwmIsCompositionEnabled","IntP",_ISENABLED) ; Get if DWM Manager is Enabled
	if !_ISENABLED ; if DWM is not enabled, Make Basic Shadow
		DllCall("Se
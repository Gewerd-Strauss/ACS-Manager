CreateHotkeyWindow(key) {      	                                                                         	;-- Hotkey Window
	GetTextSize(key,35,Verdana,height,width)
	bgTopPadding = 40
	bgWidthPadding = 100
	bgHeight = % height + bgTopPadding
	bgWidth = % width + bgWidthPadding
	padding = 20
	yPlacement = % A_ScreenHeight ?bgHeight ?padding
	xPlacement = % A_ScreenWidth ?bgWidth ?padding

	Gui, Color, 46bfec
	Gui, Margin, 0, 0
	Gui, Add, Picture, x0 y0 w%bgWidth% h%bgHeight%, C:\Users\IrisDaniela\Pictures\bg.png
	Gui, +LastFound +AlwaysOnTop -Border -SysMenu +Owner -Caption +ToolWindow
	Gui, Font, s35 cWhite, Verdana
	Gui, Add, Text, xm y20 x25 ,%key%
	Gui, Show, x%xPlacement% y%yPlacement%
	SetTimer, RemoveGui, 5000

	return

	RemoveGui:
		Gui, Destroy
	return
}
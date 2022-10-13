TabActivate(no) {																											;--
	global GuiWinTitle
	SendMessage, 0x1330, %no%,, SysTabControl321, %GuiWinTitle%
	Sleep 50
	SendMessage, 0x130C, %no%,, SysTabControl321, %GuiWinTitle%
	return
}
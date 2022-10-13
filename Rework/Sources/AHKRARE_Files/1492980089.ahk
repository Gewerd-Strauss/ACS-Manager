guiMsgBox(title, text, owner="", isEditable=0, wait=0, w="", h="") {                 	;-- GUI Message Box to allow selection

	;dependings: function - getControlInfo()

	static thebox
	wf := getControlInfo("edit", text, "w", "s9", "Lucida Console")
	hf := getControlInfo("edit", text, "h", "s9", "Lucida Console")
	w := !w ? (wf > A_ScreenWidth/1.5 ? A_ScreenWidth/1.5 : wf+200) : w 	;+10 for scl bar
	h := !h ? (hf > A_ScreenHeight ? A_ScreenHeight : hf+65) : h 		;+10 for margin, +more for the button

	Gui, guiMsgBox:New
	Gui, guiMsgBox:+Owner%owner%
	Gui, -MaximizeBox +AlwaysOnTop
	Gui, Font, s9, Lucida Console
	Gui, Add, Edit, % "x5 y5 w" w-10 " h" h-35 (isEditable ? " -" : " +") "Readonly vthebox +multi -Border", % text
	Gui, Add, button, % "x" w/2-20 " w40 y+5", OK
	GuiControl, Focus, button1
	Gui, guiMsgBox:Show, % "w" w " h" h, % title
	if wait
		while GuiEnds
			sleep 100
	return thebox

guiMsgBoxButtonOK:
guiMsgBoxGuiClose:
guiMsgBoxGuiEscape:
	Gui, guiMsgBox:Submit, nohide
	Gui, guiMsgBox:Destroy
	GuiEnds := 1
	return
}
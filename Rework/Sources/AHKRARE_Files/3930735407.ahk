getControlInfo(type="button", text="", ret="w", fontsize="", fontmore="") {			;-- get width and heights of controls
	static test
	Gui, wasteGUI:New
	Gui, wasteGUI:Font, % fontsize, % fontmore
	Gui, wasteGUI:Add, % type, vtest, % text
	GuiControlGet, test, wasteGUI:pos
	Gui, wasteGUI:Destroy
	if ret=w
		return testw
	if ret=h
		return testh
}
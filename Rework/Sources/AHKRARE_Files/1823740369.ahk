GetGuiClassStyle() {                                                                                                 	;-- returns the class style of a Autohotkey-Gui
	Gui, GetGuiClassStyleGUI:Add, Text
	Module := DllCall("GetModuleHandle", "Ptr", 0, "UPtr")
	VarSetCapacity(WNDCLASS, A_PtrSize * 10, 0)
	ClassStyle := DllCall("GetClassInfo", "Ptr", Module, "Str", "AutoHotkeyGUI", "Ptr", &WNDCLASS, "UInt")
                 ? NumGet(WNDCLASS, "Int")
                 : ""
	Gui, GetGuiClassStyleGUI:Destroy
	Return ClassStyle
}
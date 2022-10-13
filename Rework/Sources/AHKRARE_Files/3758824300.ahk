SetGuiClassStyle(HGUI, Style) {                                                                               	;-- sets the class style of a Autohotkey-Gui
	Return DllCall("SetClassLong" . (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", HGUI, "Int", -26, "Ptr", Style, "UInt")
}
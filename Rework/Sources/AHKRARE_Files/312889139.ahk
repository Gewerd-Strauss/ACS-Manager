SetParentByClass(Window_Class, Gui_Number) { 														;-- set parent window by using its window class
	Parent_Handle := DllCall( "FindWindowEx", "uint",0, "uint",0, "str", Window_Class, "uint",0)
	Gui, %Gui_Number%: +LastFound
	Return DllCall( "SetParent", "uint", WinExist(), "uint", Parent_Handle )
}
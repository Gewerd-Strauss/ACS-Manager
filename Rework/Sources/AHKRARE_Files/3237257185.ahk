Array_Gui(Array, Parent="") {                                                        	;-- shows your array as an interactive TreeView
	if !Parent
	{
		Gui, +HwndDefault
		Gui, New, +HwndGuiArray +LabelGuiArray +Resize
		Gui, Margin, 5, 5
		Gui, Add, TreeView, w300 h200

		Item := TV_Add("Array", 0, "+Expand")
		Array_Gui(Array, Item)

		Gui, Show,, GuiArray
		Gui, %Default%:Default

		WinWait, ahk_id%GuiArray%
		WinWaitClose, ahk_id%GuiArray%
		return
	}

	For Key, Value in Array
	{
		Item := TV_Add(Key, Parent)
		if (IsObject(Value))
			Array_Gui(Value, Item)
		else
			TV_Add(Value, Item)
	}
	return

	GuiArrayClose:
	Gui, Destroy
	return

	GuiArraySize:
	GuiControl, Move, SysTreeView321, % "w" A_GuiWidth - 10 " h" A_GuiHeight - 10
	return
}
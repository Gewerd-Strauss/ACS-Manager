IsControlFocused(hwnd) {																							;-- true/false if a specific control is focused
    VarSetCapacity(GuiThreadInfo, 48) , NumPut(48, GuiThreadInfo, 0)
    Return DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo) ? (hwnd = NumGet(GuiThreadInfo, 12)) ? True : False : False
}
closeContextMenu() {																									;-- a smart way to close a context menu

	;https://autohotkey.com/board/topic/23859-how-to-detect-and-close-a-context-menu/
	GuiThreadInfoSize = 48
	VarSetCapacity(GuiThreadInfo, 48)
	NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
	if not DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
	{
		MsgBox GetGUIThreadInfo() indicated a failure.
		return
	}
	; GuiThreadInfo contains a DWORD flags at byte 4
	; Bit 4 of this flag is set if the thread is in menu mode. GUI_INMENUMODE = 0x4
	if (NumGet(GuiThreadInfo, 4) & 0x4)
		send {escape}
}
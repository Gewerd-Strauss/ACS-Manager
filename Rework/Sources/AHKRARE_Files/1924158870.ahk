WM_MOVE(wParam, lParam, nMsg, hWnd) {                                  	;-- UpdateLayeredWindow

If   A_Gui
&&   DllCall("UpdateLayeredWindow", "Uint", hWnd, "Uint", 0, "int64P", (lParam<<48>>48)&0xFFFFFFFF|(lParam&0xFFFF0000)<<32>>16, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0)
WinGetPos, GuiX, GuiY,,, WinTitle
if (GuiY)
Gui, 2: Show, x%GuiX% y%GuiY%
else
Gui, 2: Show, Center
Return   0
}
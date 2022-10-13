GuiDisableMove(handle) {                       																	;-- to fix a gui/window to its coordinates
    hMenu := DllCall("user32\GetSystemMenu", "ptr", handle, "int", false, "ptr")
    DllCall("user32\RemoveMenu", "ptr", hMenu, "uint", 0xf010, "uint", 0x0)
    return DllCall("user32\DrawMenuBar", "ptr", handle)
}
GetMenuString(hMenu, uIDItem) {																				;--
    ; uIDItem: the zero-based relative position of the menu item
    Local lpString, MenuItemID
    VarSetCapacity(lpString, 4096)
    If !(DllCall("GetMenuString", "Ptr", hMenu, "UInt", uIDItem, "Str", lpString, "Int", 4096, "UInt", 0x400)) {
        MenuItemID := GetMenuItemID(hMenu, uIDItem)
        If (MenuItemID > -1) {
            Return "SEPARATOR"
        } Else {
            Return (GetSubMenu(hMenu, uIDItem)) ? "SUBMENU" : "ERROR"
        }
    }
    Return lpString
}
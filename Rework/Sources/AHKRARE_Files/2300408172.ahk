GetMenuItemCount(hMenu) {									     												;--
    Return DllCall("GetMenuItemCount", "Ptr", hMenu)
}
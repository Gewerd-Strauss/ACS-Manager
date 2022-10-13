GetSubMenu(hMenu, nPos) {																						;--
    Return DllCall("GetSubMenu", "Ptr", hMenu, "Int", nPos)
}
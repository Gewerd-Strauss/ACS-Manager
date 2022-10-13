MenuGetAll(hwnd) {																									;-- this function and MenuGetAll_sub return all Menu commands from the choosed menu

    if !menu := DllCall("GetMenu", "ptr", hwnd, "ptr")
        return ""
    MenuGetAll_sub(menu, "", cmds)
    return cmds
}
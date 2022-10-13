MenuGetAll_sub(menu, prefix, ByRef cmds) {																;-- described above

    Loop % DllCall("GetMenuItemCount", "ptr", menu) {

        VarSetCapacity(itemString, 2000)

        if !DllCall("GetMenuString", "ptr", menu, "int", A_Index-1, "str", it
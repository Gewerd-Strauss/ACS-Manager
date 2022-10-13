ShadowBorder(handle) {                                                                                          	;-- used DllCall to draw a shadow around a gui

    DllCall("user32.dll\SetClassLongPtr", "ptr", handle, "int", -26, "ptr", DllCall("user32.dll\GetClassLongPtr", "ptr", handle, "int", -26, "uptr") | 0x20000)
}
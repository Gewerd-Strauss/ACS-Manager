FrameShadow(handle) {																				            	;-- FrameShadow1
    DllCall("dwmapi.dll\DwmIsCompositionEnabled", "int*", DwmEnabled)
    if !(DwmEnabled)
        DllCall("user32.dll\SetClassLongPtr", "ptr", handle, "int", -26, "ptr", DllCall("user32.dll\GetClassLongPtr", "ptr", handle, "int", -26) | 0x20000)
   
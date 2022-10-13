SaveSetColours(set := False, liteSet := True) {                                                	            	;-- Sys colours saving adapted from an approach found in Bertrand Deo's code

	; https://gist.github.com/qwerty12/110b6e68faa60a0145198722c8b8c291
	; The rest is from Michael Maltsev: https://github.com/RaMMicHaeL/Windows-10-Color-Control
	static DWMCOLORIZATIONPARAMS, IMMERSIVE_COLOR_PREFERENCE
           ,DwmGetColorizationParameters := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "dwmapi.dll", "Ptr"), "Ptr", 127, "Ptr")
           ,DwmSetColorizationParameters := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "dwmapi.dll", "Ptr"), "Ptr", 131, "Ptr")
           ,GetUserColorPreference := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "uxtheme.dll", "Ptr"), "AStr", "GetUserColorPreference", "Ptr")
           ,SetUserColorPreference := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "uxtheme.dll", "Ptr"), "Ptr", 122, "Ptr")
           ,WM_SYSCOLORCHANGE := 0x0015, sys_colours, sav_colours, colourCount := 31, GetSysColor := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandleW", "WStr", "user32.dll", "Ptr"), "AStr", "GetSysColor", "Ptr")
	if (!set) {
        if (!VarSetCapacity(DWMCOLORIZATIONPARAMS)) {
        	VarSetCapacity(sys_colours, 4 * colourCount)
        	,VarSetCapacity(sav_colours, 4 * colourCount)
        	VarSetCapacity(DWMCOLORIZATIONPARAMS, 28)
        	,VarSetCapacity(IMMERSIVE_COLOR_PREFERENCE, 8)
        	Loop % colourCount
                NumPut(A_Index - 1, sys_colours, 4 * (A_Index - 1))
        }
        Loop % colourCount
        	NumPut(DllCall(GetSysColor, "Int", A_Index - 1, "UInt"), sav_colours, 4 * (A_Index - 1), "UInt")
        DllCall(DwmGetColorizationParameters, "Ptr", &DWMCOLORIZATIONPARAMS)
        DllCall(GetUserColorPreference, "Ptr", &IMMERSIVE_COLOR_PREFERENCE, "Int", False)
	} else {
        if (!liteSet)
        	DllCall("SetSysColors", "int", colourCount, "Ptr", &sys_colours, "Ptr", &sav_colours)
        if (VarSetCapacity(DWMCOLORIZATIONPARAMS)) {
        	if (!liteSet)
                DllCall(DwmSetColorizationParameters, "Ptr", &DWMCOLORIZATIONPARAMS, "UInt", 0)
        	DllCall(SetUserColorPreference, "Ptr", &IMMERSIVE_COLOR_PREFERENCE, "Int", True)
        }
	}
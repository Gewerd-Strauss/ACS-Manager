MinMaxInfo(W, L, M, H) {																							;--
	Static MIEX := 0, Dummy := NumPut(VarSetCapacity(MIEX, 40 + (32 << !!A_IsUnicode)), MIEX, 0, "UInt")
	Critical
	If (HMON := DllCall("User32.dll\MonitorFromWindow", "Ptr", H, "UInt", 0, "UPtr")) {
		If DllCall("User32.dll\GetMonitorInfo", "Ptr", HMON, "Ptr", &MIEX) {
			W := NumGet(MIEX, 28, "Int") - NumGet(MIEX, 20, "Int")
			H := NumGet(MIEX, 32, "Int") - NumGet(MIEX, 24, "Int")
			NumPut(W - NumGet(L + 16, "Int"), L + 8, "Int")
			NumPut(H - NumGet(L + 20, "Int"), L + 12, "Int")
		}
	}
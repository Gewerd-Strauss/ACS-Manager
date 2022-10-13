SetWindowTransistionDisable(hwnd,onOff) {																;-- disabling fade effect only the window of choice
	dwAttribute:=3
	cbAttribute:=4
	VarSetCapacity(pvAttribute,4,0)
	NumPut(onOff,pvAttribute,0,"Int")
	hr:=DllCall("Dwmapi.dll\DwmSetWindowAttribute", "Uint", hwnd, "Uint", dwAttribute, "Uint", &pvAttribute, "Uint", cbAttribute)
	return hr
}
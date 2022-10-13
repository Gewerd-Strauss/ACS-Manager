GetFontTextDimension(hFont, Text, ByRef Width := "", ByRef Height := "", c := 1) {  	;-- calculate the height and width of the text in the specified font
	hFont := hFont?hFont:GetStockObject(17), hDC := GetDC()
	, hSelectObj := SelectObject(hDC, hFont), VarSetCapacity(SIZE, 8, 0)
	if !DllCall("Gdi32.dll\GetTextExtentPoint32W", "Ptr", hDC, "Ptr", &Text, "Int", StrLen(Text), "Ptr", &SIZE, "Int")
		return false, ReleaseDC(0, hDC), Width := Height := 0
	VarSetCapacity(TEXTMETRIC, 60, 0)
	if !DllCall("Gdi32.dll\GetTextMetricsW", "Ptr", hDC, "Ptr", &TEXTMETRIC, "Int") ;https://msdn.microsoft.com/en-us/library/dd144941(v=vs.85).aspx
		return false, ReleaseDC(0, hDC), Width := Height := 0
	SelectObject(hDC, hSelectObj), ReleaseDC(0, hDC), Width := NumGet(SIZE, 0, "Int"), Height := NumGet(SIZE, 4, "Int")
	, Width := Width + NumGet(TEXTMETRIC, 20, "Int") * 3
	, Height := Floor((NumGet(TEXTMETRIC, 0, "Int")*c)+(NumGet(TEXTMETRIC,16, "Int")*(Floor(c+0.5)-1))+0.5)+8
	return true
}
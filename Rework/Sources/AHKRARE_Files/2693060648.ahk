MouseGetText(x := "", y := "", Encoding := "UTF-16") {                                                      	;-- get the text in the specified coordinates, function uses Microsoft UIA


	static uia
	if (x="") || (y="")
		CursorGetPos(_x, _y), x := x=""?_x:x, y := y=""?_y:y
	if !(uia) ;https://msdn.microsoft.com/en-us/library/windows/desktop/ff384838%28v=vs.85%29.aspx
		uia := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
	Item := {}, Dl
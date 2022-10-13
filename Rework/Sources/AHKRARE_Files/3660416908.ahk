WinEnum(hwnd:=0, lParam:=0) {                                                                            	;-- wrapper for Enum(Child)Windows from cocobelgica. a different solution to that one I collected before
	static pWinEnum := "X"
	if (A_EventInfo != pWinEnum) {
		if (pWinEnum == "X")
			pWinEnum := RegisterCallback(A_ThisFunc, "F", 2)
		if hwnd {

			;// not a window handle, could be a WinTitle parameter
			if !DllCall("IsWindow", "Ptr", hwnd) {

				prev_DHW := A_DetectHiddenWindows
				prev_TMM := A_TitleMatchMode
				DetectHiddenWindows On
				SetTitleMatchMode 2
				hwnd := WinExist(hwnd)
				DetectHiddenWindows %prev_DHW%
				SetTitleMatchMode %prev_TMM%

			}
		}
		out := []
		if hwnd
			DllCall("EnumChildWindows", "Ptr", hwnd, "Ptr", pWinEnum, "Ptr", &out)
		else
			DllCall("EnumWindows", "Ptr", pWinEnum, "Ptr", &out)
		return out
	}

	;// Callback - EnumWindowsProc / EnumChildProc
	static ObjPush := Func(A_AhkVersion < "2" ? "ObjInsert" : "ObjPush")
	%ObjPush%(Object(lParam + 0), hwnd)
	return true
}
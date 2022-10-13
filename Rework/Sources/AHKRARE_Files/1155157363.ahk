GetScriptVARs() {																										;-- returns a key, value array with all script variables (e.g. for debugging purposes)

		; http://www.autohotkey.com/board/topic/20925-listvars/#entry156570

	global
	static hEdit, pSFW, pSW, bkpSFW, bkpSW
	local dhw, AStr, Ptr, hmod, text, v, i := 0, vars := []

	if !hEdit {
		dhw := A_DetectHiddenWindows
		DetectHiddenWindows, On
		ControlGet, hEdit, Hwnd,, Edit1, % "ahk_id " A_ScriptHwnd
		DetectHiddenWindows, % dhw

		AStr := A_IsUnicode ? "AStr" : "Str"
		Ptr := A_PtrSize=8 ? "Ptr" : "UInt"
		hmod := DllCall("GetModuleHandle", "Str", "user32.dll")
		pSFW := DllCall("GetProcAddress", Ptr, hmod, AStr, "SetForegroundWindow")
		pSW := DllCall("GetProcAddress", Ptr, hmod, AStr, "ShowWindow")
		DllCall("VirtualProtect", Ptr, pSFW, Ptr, 8, "UInt", 0x40, "UInt*", 0)
		DllCall("VirtualProtect", Ptr, pSW, Ptr, 8, "UInt", 0x40, "UInt*", 0)
		bkpSFW := NumGet(pSFW+0, 0, "int64")
		bkpSW := NumGet(pSW+0, 0, "int64")
	}

	if (A_PtrSize=8) {
        NumPut(0x0000C300000001B8, pSFW+0, 0, "int64")  ; return TRUE
        NumPut(0x0000C300000001B8, pSW+0, 0, "int64")   ; return TRUE
    } else {
        NumPut(0x0004C200000001B8, pSFW+0, 0, "int64")  ; return TRUE
        NumPut(0x0008C200000001B8, pSW+0, 0, "int64")   ; return TRUE
    }

    ListVars

    NumPut(bkpSFW, pSFW+0, 0, "int64")
    NumPut(bkpSW, pSW+0, 0, "int64")

    ControlGetText, text,, % "ahk_id " hEdit

    RegExMatch(text, "sm)(?<=^Global Variables \(alphabetical\)`r`n-{50}`r`n).*", text)
    Loop, Parse, text, `n, `r
    {
    	if (A_LoopField~="^\d+\[") || (A_LoopField = "")
    		continue
		v := SubStr(A_LoopField, 1, InStr(A_LoopField, "[")-1)
    	vars[i+=1] := {name: v, value:%v%}
    }
    return vars
}
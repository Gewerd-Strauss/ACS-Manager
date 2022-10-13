ListAHKStats(Section="ListVars") {                                                                              	;-- Select desired section: ListLines, ListVars, ListHotkeys, KeyHistory

	; Based on the "ListVars" feature of Lexikos
	; http://www.autohotkey.com/forum/post-165430.html#165430
	; extensions MEC: http://ahkscript.org/germans/forums/viewtopic.php?t=8080
	; Select desired section: ListLines, ListVars, ListHotkeys, KeyHistory
	; Passed data KeyHistory cleaned up with explanatory text

    static hwndEdit, pSFW, pSW, bkpSFW, bkpSW
    if !hwndEdit
    {
        dhw := A_DetectHiddenWindows
        DetectHiddenWindows, On
        Process, Exist
        ControlGet, hwndEdit, Hwnd,, Edit1, ahk_class AutoHotkey ahk_pid %ErrorLevel%
        DetectHiddenWindows, %dhw%

        astr := A_IsUnicode ? "astr":"str"
        ptr := A_PtrSize=8 ? "ptr":"uint"
        hmod := DllCall("GetModuleHandle", "str", "user32.dll")
        pSFW := DllCall("GetProcAddress", ptr, hmod, astr, "SetForegroundWindow")
        pSW := DllCall("GetProcAddress", ptr, hmod, astr, "ShowWindow")
        DllCall("VirtualProtect", ptr, pSFW, ptr, 8, "uint", 0x40, "uint*", 0)
        DllCall("VirtualProtect", ptr, pSW, ptr, 8, "uint", 0x40, "uint*", 0)
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

      ;added by MEC:
      ;Section: "ListLines","ListVars","ListHotkeys","KeyHistory"
      If (Section="ListLines")
         ListLines
      Else
         If (Section="ListVars")
            ListVars
         Else
            If (Section="ListHotkeys")
               ListHotkeys
            Else
               KeyHistory

    NumPut(bkpSFW, pSFW+0, 0, "int64")
    NumPut(bkpSW, pSW+0, 0, "int64")

    ControlGetText, text,, ahk_id %hwndEdit%

      ;---MEC: Text explanations cut out and out with them
      If (Section="KeyHistory") {
         pos:=InStr(text, "NOTE:" ,"", 200)
         text1:=SubStr(text, 1, pos-1)
         pos:=InStr(text, "#IfWinActive/Exist" ,"", pos)
         text:=SubStr(text, pos +23)
         text:=text1 . text
         }
    return tex
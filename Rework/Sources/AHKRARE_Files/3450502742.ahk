GetClientSize(hwnd, ByRef w, ByRef h) {																		;-- get size of window without border
	; https://autohotkey.com/board/topic/91733-command-to-get-gui-client-areas-sizes/
    VarSetCapacity(rc, 16)
    DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
    w := NumGet(rc, 8, "int")
    h := NumGet(rc, 12, "int")
}
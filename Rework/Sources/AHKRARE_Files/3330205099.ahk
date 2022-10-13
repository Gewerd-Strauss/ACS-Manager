GetMenu(hWnd) {																										;-- returns hMenu handle
	;; only wraps DllCall(GetMenu)
    Return DllCall("GetMenu", "Ptr", hWnd)
}
GetClassName( hwnd ) { 																						    	;-- returns HWND's class name without its instance number, e.g. "Edit" or "SysListView32"
		;https://autohotkey.com/board/topic/45515-remap-hjkl-to-act-like-left-up-down-right-arrow-keys/#entry283368
		VarSetCapacity( buff, 256, 0 )
		DllCall("GetClassName", "uint", hwnd, "str", buff, "int", 255 )
return buff
}
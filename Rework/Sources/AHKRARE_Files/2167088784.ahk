DisableCloseButton(hWnd) {																						;-- to disable/grey out the close button
	hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
	nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
	DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
	DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
	DllCall("DrawMenuBar","Int",hWnd)
}
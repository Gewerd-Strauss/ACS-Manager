unmovable() {																												;-- makes Gui unmovable
	; make Gui unmovable -code by SKAN-
Gui 2:+LastFound
Gui1 := WinExist()
hSysMenu:=DllCall("GetSystemMenu","Int",Gui1,"Int",FALSE)
nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-6,"Uint","0x400")
DllCall("DrawMenuBar","Int",Gui1)
; end block
}
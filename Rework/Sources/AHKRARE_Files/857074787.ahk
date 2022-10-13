TabActivate(TabName, WinTitle="") {																			;-- a different approach to activate a Tab in IE - function uses acc.ahk library
	ControlGet, hTabUI , hWnd,, DirectUIHWND5, % WinTitle=""? "ahk_class IEFrame":WinTitle
	Tabs := Acc_ObjectFromWindow(hTabUI).accChild(1) ; access "Tabs" control
	Loop, % Tabs.accChildCount
		if (Tabs.accChild(A_Index).accName(0) = TabName)
			return, Tabs.accChild(A_Index).accDoDefaultAction(0)
}
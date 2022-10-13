IE_TabActivateByName(TabName, WinTitle="") {														;-- activate a TAB by name in InternetExplorer

	/*                              	DESCRIPTION

			Link: https://autohotkey.com/boards/viewtopic.php?f=9&t=542

	*/
	ControlGet, hTabUI , hWnd,, DirectUIHWND5, % WinTitle=""? "ahk_class IEFrame":WinTitle
	Tabs := Acc_ObjectFromWindow(hTabUI).accChild(1) ; access "Tabs" control
	Loop, % Tabs.accChildCount
		if (Tabs.accChild(A_Index).accName(0) = TabName)
			return, Tabs.accChild(A_Index).accDoDefaultAction(0)
}
listAccChildProperty(hwnd){	;--

	COM_AccInit()
	If	pacc :=	COM_AccessibleObjectFromWindow(hWnd)
	{
		;~ VarSetCapacity(l,4),VarSetCapacity(t,4),VarSetCapacity(w,4),VarSetCapacity(h,4)
		;~ COM_Invoke(pacc,"accLocation",l,t,w,h,0)
		;~ a:=COM_Invoke(pacc,"accParent")

		sResult	:="[Window]`n"
			. "Name:`t`t"		COM_Invoke(pacc,"accName",0) "`n"
			. "Value:`t`t"		COM_Invoke(pacc,"accValue",0) "`n"
			. "Description:`t"	COM_Invoke(pacc,"accDescription",0) "`n"
			. COM_Invoke(pacc,"accDefaultAction",0) "`n"
			. COM_Invoke(pacc,"accHelp",0) "`n"
			. COM_Invoke(pacc,"accKeyboardShortcut",0) "`n"
			. COM_Invoke(pacc,"accRole",0) "`n"
			. COM_Invoke(pacc,"accState",0) "`n"
		Loop, %	COM_AccessibleChildren(pacc, COM_Invoke(pacc,"accChildCount"), varChildren)
			If	NumGet(varChildren,16*(A_Index-1),"Ushort")=3 && idChild:=NumGet(varChildren,16*A_Index-8)
				sResult	.="[" A_Index "]`n"
					. "Name:`t`t"		COM_Invoke(pacc,"accName
HideFocusBorder(wParam, lParam := "", Msg := "", handle := "") {								;-- hides the focus border for the given GUI control or GUI and all of its children

	/*                              	DESCRIPTION

			 by 'just me'
			 Hides the focus border for the given GUI control or GUI and all of its children.
			 Call the function passing only the HWND of the control / GUI in wParam as only parameter.
			 WM_UPDATEUISTATE  -> msdn.microsoft.com/en-us/library/ms646361(v=vs.85).aspx
			 The Old New Thing -> blogs.msdn.com/b/oldnewthing/archive/2013/05/16/10419105.aspx

	*/

	static Affect
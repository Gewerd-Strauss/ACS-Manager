GetOtherControl(refHwnd,shift,controls,type="hwnd") {                                        	;--
	for k,v in controls
		if v[type]=refHwnd
			return controls[k+shift].hwnd
}
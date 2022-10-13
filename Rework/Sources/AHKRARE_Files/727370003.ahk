GetControls(hwnd, controls="") {                                                                            	;-- returns an array with ClassNN, Hwnd and text of all controls of a window

	if !isobject(controls)
		controls:=[]

	if isobject(hwnd){
		for k,v in hwnd
			controls:=GetControls(v, controls)
		return controls
	}

	winget,classnn,ControlList,ahk_id %hwnd%
	winget,controlId,controllisthwnd,ahk_id %hwnd%
	loop,parse,classnn,`n
	{
		controls[a_index]:=[]
		controls[a_index]["ClassNN"]:=a_loopfield
	}

	loop,parse,controlId,`n
	{
		controls[a_index]["Hwnd"]:=a_loopfield
		controlgetText,txt,,ahk_id %a_loopfield%
		controls[a_index]["text"]:=txt
	}
	return controls
}
GetInfoUnderCursor() {                                                                                                	;-- retreavies ACC-Child under cursor
	Acc := Acc_ObjectFromPoint(child)
	if !value := Acc.accValue(child)
		value := Acc.accName(child)
	accPath := GetAccPath(acc, hwnd).path
	return {text: value, path: accPath, hwnd: hwnd}
}
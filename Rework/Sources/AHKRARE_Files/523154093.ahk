LV_SetColOrder(hCtl, oList, vSep:="") {																			;-- pass listview hWnd (not listview header hWnd)
	if !IsObject(oList)
	oList := StrSplit(oList, vSep)
	if !(vCountCol := oList.Length())
	return

	vErr := A_PtrSize=8 && JEE_WinIs64Bit(hCtl) ? -1 : 0xFFFFFFFF
	vScriptPID := DllCall("kernel32\GetCurrentProcessId", UInt)
	vPID := WinGetPID("ahk_id " hCtl)
	if (vPID = vScriptPID)
	vIsLocal := 1, vPIs64 := (A_PtrSize=8)

	if 
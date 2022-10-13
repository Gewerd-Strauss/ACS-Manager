LV_GetColOrder(hCtl, vSep:="") {																					;-- returns the order of listview columns for a listview

	;pass listview hWnd (not listview header hWnd)
	vErr := A_PtrSize=8 && JEE_WinIs64Bit(hCtl) ? -1 : 0xFFFFFFFF
	vScriptPID := DllCall("kernel32\GetCurrentProcessId", UInt)
	vPID := WinGetPID("ahk_id " hCtl)
	if (vPID = vScriptPID)
	vIsLocal := 1, vPIs64 := (A_PtrSize=8)

	if !hLVH := SendMessage(0x101F,,,, "ahk_id " hCtl) ;LVM_GETHEADER := 0x101F
	return
	if !vCountCol := SendMessage(0x1200,,,, "ahk_id " hLVH) ;HDM_GETITEMCOUNT := 0x1200
	return
	if (vCountCol = vErr) ;-1
	return

	if !vIsLocal
	{
		if !hProc := JEE_DCOpenProcess(0x438, 0, vPID)
			return
		if A_Is64bitOS && !DllCall("kernel32\IsWow64Process", Ptr,hProc, PtrP,vIsWow64Process)
			return
		vPIs64 := !vIsWow64Process
	}

	vPtrType := vPIs64?"Int64":"Int"
	vSize := vCountCol*4
	VarSetCapacity(vData, vSize, 0)

	if !vIsLocal
		if !pBuf := JEE_DCVirtualAllocEx(hProc, 0, vSize, 0x3000, 0x4)
			return
	else
		pBuf := &vData

	SendMessage(0x103B, vCountCol, pBuf,, "ahk_id " hCtl) ;LVM_GETCOLUMNORDERARRAY := 0x103B
	if !vIsLocal
	
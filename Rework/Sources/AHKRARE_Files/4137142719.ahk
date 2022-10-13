getByControlName(winHwnd,name) {																		;-- search by control name return hwnd

	winget,controlList,controlListhwnd,ahk_id %winHwnd%
    arr:=[]
    ,bufSize=1024
	winget,processID,pid,ahk_id %winHwnd%
	VarSetCapacity(var1,bufSize)
	if !(getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" ))
        return []
	if !(dwResult:=DllCall("GetWindowThreadProcessId", "UInt", winHwnd))
        return []
	if !(hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID))
        return []
    if !(otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr"))
        return []

	loop,parse,controlList,`n
	{
        SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %a_loopfield%
        if err
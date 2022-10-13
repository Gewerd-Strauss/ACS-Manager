getActiveProcessName() {                                                                                           	;-- this function finds the process to the 'ForegroundWindow'
	;by Lexikos  https://autohotkey.com/boards/viewtopic.php?p=73137#p73137
	handle := DllCall("GetForegroundWindow", "Ptr")
	DllCall("GetWindowThreadProcessId", "Int", handle, "int*", pid)
	global true_pid := pid
	callback := RegisterCallback("enumChildCallback", "Fast")
	DllCall("EnumChildWindows", "Int", handle, "ptr", callback, "int", pid)
	handle := DllCall("OpenProcess", "Int", 0x0400, "Int", 0, "Int", true_pid)
	length := 259 ;max path length in windows
	VarSetCapacity(name, length)
	DllCall("QueryFullProcessImageName", "Int", handle, "Int", 0, "Ptr", &name, "int*", length)
	SplitPath, name, pname
	return pname
}
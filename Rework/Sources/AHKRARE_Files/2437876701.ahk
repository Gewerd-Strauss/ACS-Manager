Is64bitProcess(pid) {                                                                                                	;-- check if a process is running in 64bit

	;function from Toolbar.ahk - Scite4AHK
	if !A_Is64bitOS
		return 0

	proc := DllCall("OpenProcess", "uint", 0x0400, "uint", 0, "uint", pid, "ptr")
	DllCall("IsWow64Process", "ptr", proc, "uint*", retval)
	DllCall("CloseHandle", "ptr", proc)
	return retval ? 0 : 1
}
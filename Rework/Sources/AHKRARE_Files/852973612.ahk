processPriority(PID) {                                                                                                   	;-- retrieves the priority of a process via PID
	return dllCall("GetPriorityClass","UInt",dllCall("OpenProcess","Uint",0x400,"Int",0,"UInt",PID)),dllCall("CloseHandle","Uint",hProc)
}
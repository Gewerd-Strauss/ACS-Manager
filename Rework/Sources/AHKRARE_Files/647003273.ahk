GetPriority(process="") {                                                                                             	;-- ascertains the priority level for an existing process
	 Process, Exist, %process%
	 PID := ErrorLevel
	 IfLessOrEqual, PID, 0, Return, "Error!"

	 hProcess := DllCall("OpenProcess", Int,1024, Int,0, Int,PID)
	 Priority := DllCall("GetPriorityClass", Int,hProcess)
	 DllCall("CloseHandle", Int,hProcess)

	 IfEqual, Priority, 64   		, Return, "Low"
	 IfEqual, Priority, 16384	, Return, "BelowNormal"
	 IfEqual, Priority, 32   		, Return, "No
GetProcessMemoryInfo(PID,Units:="M") {                                                                  	;-- get informations about memory consumption of a process
	size := (A_PtrSize=8 ? 80 : 44)
	VarSetCapacity(mem,size,0)
	memory := 0
	hProcess := DllCall("OpenProcess", UInt,0x400|0x0010,Int,0,Ptr,PID, Ptr)
	if (hProcess){
		if (DllCall("psapi.dll\GetProcessMemoryInfo", Ptr, hProcess, Ptr, &mem, UInt,size))
			memory := Round(NumGet(mem, (A_PtrSize=8 ? 16 : 12), "Ptr"))
		DllCall("CloseHandle", Ptr, hProcess)

		if(Units == "raw"){
				return % memory
		}else	if(Units == "Cust"){
			memory := Round(memory/1024)
			if(memory<40000){
				RegExMatch(memory,"(\d+)(\d{3})$", out)
				memory:=out1 "," out2
				return % memory " KB"
			}else{
				memory := Round(memory/1024)
				return % memory " MB"
			}
		}else	if(Units == "B"){
					memory := memory  " B"
		}else if(Units == "K"){
					memory := Round(memory/1024)  " KB"
		}else if(Units == "M"){
					memory := Round(memory / 1024 / 1024)	 " MB"
		}
		return % memory
	}
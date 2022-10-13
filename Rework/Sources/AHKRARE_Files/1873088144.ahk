ProcessPriority(PID:="", PS:="") {                                                                                  	;-- Useful inside a library function to save/set/reset script's Process priority
	Local hProc, PG:=0, PROCESS_QUERY_INFORMATION:=0x0400
	  Process, Exist, %PID%
	  If ! ( Errorlevel := ! (PID:=ErrorLevel) )
		{
			hProc := DllCall("OpenProcess", "UInt",PROCESS_QUERY_INFORMATION, "UInt",0, "Ptr",PID, "Ptr")
			PG := DllCall("GetPriorityClass", "Ptr",hProc, "UInt")
			DllCall("CloseHandle", "Ptr",hProc)

			If InStr("|Low|BelowNormal|Normal|AboveNormal|High|Realtime|", "|" . PS . "|")
			  {
				Process, Priority, %PID%, %PS%
				ErrorLevel := ! (ErrorLevel=PID)
			  }
		}

Return {0x40:"Low",0x4000:"BelowNormal",0x20:"Normal",0x8000:"AboveNormal",0x80:"High",0x100:"Realtime"}[PG]
}
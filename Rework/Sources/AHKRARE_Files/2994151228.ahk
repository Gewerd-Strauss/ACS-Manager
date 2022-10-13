ProcessCreationTime(PID) {                                                                                         	;-- ascertains the creation time for an existing process and returns a time string
	 hPr := DllCall( "OpenProcess", UInt,1040, Int,0, Int,PID )
	 DllCall( "GetProcessTimes", UInt,hPr, Int64P,UTC, Int,0, Int,0, Int,0 )
	 DllCall( "CloseHandle", Int,hPr)
	 DllCall( "FileTimeToLocalFileTime", Int64P,UTC, Int64P,Local ), AT := 1601
	 AT += % Local//10000000, S
Return AT
}
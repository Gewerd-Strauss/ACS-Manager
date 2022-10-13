ProcessOwner(PID) {                                                                                                     	;-- returns the Owner for a given Process ID
	 ; PROCESS_QUERY_INFORMATION=0x400, TOKEN_READ:=0x20008, TokenUser:=0x1
	 hProcess := DllCall( "OpenProcess", UInt,0x400,Int,0,UInt,PID )
	 DllCall( "Advapi32.dll\OpenProcessToken", UInt,hProcess, UInt,0x20008, UIntP,Tok )
	 DllCall( "Advapi32.dll\GetTokenInformation", UInt,Tok, UInt,0x1, Int,0, Int,0, UIntP,RL )
	 VarS
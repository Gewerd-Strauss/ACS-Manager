RtlGetVersion() {																											;-- retrieves version of installed windows system

	; https://github.com/jNizM/ahk_pi-hole/blob/master/src/pi-hole.ahk
	 ; https://msdn.microsoft.com/en-us/library/mt723418(v=vs.85).aspx
	; 0x0A00 - Windows 10
	; 0x0603 - Windows 8.1
	; 0x0602 - Windows 8 / Windows Server 2012
	; 0x0601 - Windows 7 / Windows Server 2008 R2
	; 0x0600 - Windows Vista / Windows Server 2008
	; 0x0502 - Windows XP 64-Bit Edition / Windows Server 2003 / Windows Server 2003 R2
	; 0x0501 - Windows XP
	; 0x0500 - Windows 2000
	; 0x0400 - Windows NT 4.0
	static RTL_OSV_EX, init := NumPut(VarSetCapacity(RTL_OSV_EX, A_IsUnicode ? 284 : 156, 0), RTL_OSV_EX, "uint")
	if (DllCall("ntdll\RtlGetVersion", "ptr", &RTL_OSV_EX) != 0)
		throw Exception("RtlGetVersion failed", -1)
	return ((NumGet(RTL_OSV_EX, 4, "uint") << 8) | NumGet(RTL_OSV_EX, 8, "uint"))
}
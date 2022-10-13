GetPhysicallyInstalledSystemMemory() {                                                               	;-- recovers the amount of RAM in physically installed KB from the SMBIOS (System Management BIOS) firmware tables, WIN_V SP1+
	/*                              	DESCRIPTION

			Example: MsgBox % Round(GetPhysicallyInstalledSystemMemory()/1024, 1) " MB"
			Note: to recover only RAM, use GlobalMemoryStatus (). TotalPhys

	*/
	DllCall("Kernel32.dll\GetPhysicallyInstalledSystemMemory", "Int64P", TotalMemo
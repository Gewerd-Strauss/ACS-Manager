VirtualFree(hProcess := 0, Address := 0, Bytes := 0, AllocationType := 0x8000) {       	;-- release a region of pages within the virtual address space of the specified process
	/*                              	DESCRIPTION
			Syntax: VirtualFree( [hProcess], [direccion], [tamaño, en bytes], [tipo] )
			Types:
			MEM_DECOMMIT = 0x4000
			MEM_RELEASE (default) = 0x8000
	*/

	Error := ErrorLevel
	if !(hProcess) ;VirtualFree | else VirtualFreeEx + hProcess
		return DllCall("Kernel32.dll\VirtualFree", "UInt", Address, "UPtr", Bytes, "UInt", AllocationType, "UInt"), ErrorLevel := Error
	return DllCall("Kernel32.dll\VirtualFreeEx", "Ptr", hProcess, "UInt", Address, "UPtr", Bytes, "UInt", AllocationType, "UInt"), ErrorLevel := Error
}
VirtualAlloc(ByRef hProcess := 0, ByRef Address := 0                                                  	;-- changes the state of a region of memory within the virtual address space of a specified process. the memory is assigned to zero.AtEOF
, ByRef Bytes := 0, AllocationType := 0x00001000, Protect := 0x04, Preferred := 0) {

	/*                              	DESCRIPTION

			Syntax: VirtualAlloc ([hProcess], [address], [size], [type], [protection], [NUMA])
			hProcess (optional): HANDLE a process, if it is not used, use the current process.
			Address (optional): start address of the assign Region
			Size: size of the region, in bytes
			Type: type of memory allocation
			MEM_COMMIT (default) = 0x00001000
			MEM_RESERVE = 0x00002000
			
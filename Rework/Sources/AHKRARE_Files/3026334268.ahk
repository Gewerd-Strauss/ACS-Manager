GlobalMemoryStatus() {                                                                                          	;-- retrieves information about the current use of physical and virtual memory of the system

	VarSetCapacity(MEMORYSTATUSEX, 64, 0), NumPut(64, MEMORYSTATUSEX, "UInt")
	r := DllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", &MEMORYSTATUSEX)
	return !r?false:{Load: NumGet(MEMORYSTATUSEX, 4, "UInt") ;n�mero entre 0 y 100 que especifica el porcentaje aproximado de la memoria f�sica que est� en uso
	, TotalPhys: NumGet(MEMORYSTATUSEX, 8, "UI
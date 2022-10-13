LocalFree(hMem*) {                                                                                                     	;-- free a locked memory object
	Error := ErrorLevel, Ok := 0
	for k, v in hMem
		Ok += !DllCall("Kernel32.dll\LocalFree", "Ptr", v, "Ptr")
	return Ok=hMem.MaxIndex(), ErrorLevel := Error
}
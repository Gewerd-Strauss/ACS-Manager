ReadProcessMemory(hProcess, BaseAddress, Buffer, Bytes := 0                                	;-- reads data from a memory area in a given process.
, ByRef NumberOfBytesRead := "", ReturnType := "UInt") {

		/*                              	DESCRIPTION

			The entire area to be read must be accessible or the operation will fail
			Syntax:                 ReadProcessMemory ([hProcess], [BaseAddress], [data (out)], [size, in bytes], [NumberOfBytesRead (in_out)], [ReturnType])
			Parameters:			BaseAddress: a pointer to the base address in the specific process to read
			Data:                 	A pointer to a buffer that receives the contents of the address space of the specified process.
			Size:                 	the number of bytes that is read from the specified processNumberOfBytesRead: receives the number of bytes transferred in the specified bufferReturnType: type of value to return. defect = UInt

	*/
	BaseAddress := IsObject(BaseAddress)?BaseAddress:["UInt", BaseAddress], Error := ErrorLevel
	if IsByRef(NumberOfBytesRead)
		VarSetCapacity(NumberOfBytesRead, NumberOfBytesRead?NumberOfBytesRead:16, 0)
	Result := DllCall("Kernel32.dll\ReadProcessMemory", "Ptr", hProcess, BaseAddress[1], BaseAddress[2], "Ptr", Buffer, "UPtr"
	, Bytes>0?Bytes:VarSetCapacity(Buffer), "UPtrP", IsByRef(NumberOfBytesRead)?&NumberOfBytesRead:0, ReturnType)
	if IsByRef(NumberOfBytesRead)
		NumberOfBytesRead := NumGet(NumberOfBytesRead, 0, "UPtrP")
	return Result, ErrorLevel := Error
}
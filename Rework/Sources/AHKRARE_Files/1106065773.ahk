WriteProcessMemory(hProcess, BaseAddress                                                            	;-- writes data to a memory area in a specified process. the entire area to be written must be accessible or the operation will fail
, Buffer, Bytes := 0, ByRef NumberOfBytesWritten := "") {

	/*                              	DESCRIPTION

			Syntax: WriteProcessMemory( [hProcess], [BaseAddress], [Buffer], [Size], [NumberOfBytesWritten] )

	*/

	BaseAddress := IsObject(BaseAddress)?BaseAddress:["UInt", BaseAddress], Error := ErrorLevel
	if IsByRef(NumberOfBytesWritten)
		VarSetCapacity(NumberOfBytesWritten, 16, 0)
	Result :=  DllCall("Kernel32.dll\WriteProcessMemory", "Ptr", hProcess, BaseAddress[1], BaseAddress[2], "Ptr", Buffer, "UPtr"
	, Bytes>0?Bytes:VarSetCapacity(Buffer), "UPtrP", IsByRef(NumberOfBytesWritten)?&NumberOfBytesWritten:0, "UInt")
	if IsByRef(NumberOfBytesWritten)
		NumberOfBytesWritten := NumGet(NumberOfBytesWritten, 0, "UPtrP")
	return Result, ErrorLevel := Error
}
FillMemory(ByRef Destination, Bytes, Fill) {                                                                  	;-- fills a block of memory with the specified value
	;Syntax: FillMemory ([destination], [bytes], [value])
	DllCall("ntdll.dll\RtlFillMemory", "Ptr", Destination, "UInt", Bytes, "UChar", Fill)
}
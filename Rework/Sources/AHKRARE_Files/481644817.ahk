ZeroMemory(ByRef Destination, Bytes) {                                                                    	;-- fills a memory block with zeros
	DllCall("ntdll.dll\RtlZeroMemory", "Ptr", Destination, "UInt", Bytes)
}
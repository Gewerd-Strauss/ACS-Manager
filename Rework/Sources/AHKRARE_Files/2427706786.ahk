CoTaskMemFree(ByRef hMem) {                                                                                 	;-- releases a memory block from a previously assigned task through a call to the CoTaskMemAlloc () or CoTaskMemAlloc () function.
	Error := ErrorLevel
	, Ok := DllCall("Ole32.dll\CoTaskMemFree", "UPtr", hMem)
	return !!Ok, VarSetCapacity(hMem, 0), ErrorLevel := Error

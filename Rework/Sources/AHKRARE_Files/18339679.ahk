GlobalLock(hMem) {                                                                                                    	;-- memory management functions
	return DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")
} GlobalAlloc(Bytes, Flags := 0x0002) {
	return DllCall("Kernel32.dll\GlobalAlloc", "UInt", Flags, "UInt", Bytes, "Ptr")
} GlobalReAlloc(hMem, Bytes, Flags := 0x0002) {
	return DllCall("Kernel32.dll\GlobalReAlloc", "Ptr", hMem, "UInt", Bytes, "UInt", Flags, "Ptr")
} GlobalUnlock(hMem) {
	return DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "UInt")
} GlobalFree(hMem) {
	return DllCall("Kernel32.dll\GlobalFree", "Ptr", hMem, "Ptr")
} GlobalSize(hMem) {
	return DllCall("Kernel32.dll\GlobalSize", "Ptr", hMem, "UInt")
} GlobalDiscard(hMem) {
	return DllCall("Kernel32.dll\GlobalDiscard", "Ptr", hMem, "Ptr")
} GlobalFlags(hMem) {
	return DllCall("Kernel32.dll\GlobalFlags", "Ptr", hMem, "UInt")
}
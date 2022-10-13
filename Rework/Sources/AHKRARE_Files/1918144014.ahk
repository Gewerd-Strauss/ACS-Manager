GetSystemFileCacheSize(ByRef MinimumFileCacheSize := "", ByRef MaximumFileCacheSize := "", ByRef Flags := ""){                        	;-- retrieves the current size limits for the working set of the system cache
	return DllCall("Kernel32.dll\GetSystemFileCacheSize", "Int64P", MinimumFileCacheSize, "Int64P", MaximumFileCacheSize, "UIntP", Flags)
}
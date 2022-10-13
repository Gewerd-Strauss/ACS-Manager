GetHandleInformation(Handle, ByRef Flags := "") {                                                	;-- obtain certain properties of a HANDLE

	/*                              	DESCRIPTION

			; https: //msdn.microsoft.com/en-us/library/windows/desktop/ms724329 (v = vs.85) .aspx
			; obtain certain properties of a HANDLE
			; Syntax: GetHandleInformation ([HANDLE], [flags])
			; Parameters:
			; Flags: can be one of the following values.
			; 0x00000000
			; 0x00000001 = HANDLE_FLAG_INHERIT
			; 0x00000002 = HANDLE_FLAG_PROTECT_FROM_CLOSE
			; Return: 0 | 1
			; ErrorLevel:
			; 1 = OK
			; 6 = the HANDLE is invalid
			; [another] = see https://msdn.microsoft.com/en-us/library/ms681382(v=vs.85).aspx

	*/
	Ok := DllCall("Kernel32.dll\GetHandleInformation", "Ptr", Handle, "UIntP", Flags)
	return !!Ok, ErrorLevel := Ok?false:A_LastError
}
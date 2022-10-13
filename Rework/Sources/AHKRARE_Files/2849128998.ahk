GetImageType(PID) {																							;-- returns whether a process is 32bit or 64bit

	; PROCESS_QUERY_INFORMATION
    hProc := DllCall("OpenProcess", "UInt", 0x400, "Int", False, "UInt", PID, "Ptr")
    If (!hProc) {
        Return "N/A"
    }

    If (A_Is64bitOS) {
        ; Determines whether the specified process is running under WOW64.
        Try DllCall("IsWow64Process", "Ptr", hProc, "Int*", Is32Bit := True)
    } Else {
        Is32Bit := True
    }

    DllCall("CloseHandle", "Ptr", hProc)

    Return (Is32Bit) ? "32-bit" : "64-bit"
}
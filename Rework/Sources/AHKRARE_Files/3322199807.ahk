KillProcess(proc) {                                                                                                        	;-- uses DllCalls to end a process

	; https://autohotkey.com/board/topic/119052-check-if-a-process-exists-if-it-does-kill-it/page-2

    static SYNCHRONIZE                 := 0x00100000
    static STANDARD_RIGHTS_REQUIRED    := 0x000F0000
    static OSVERSION                   := (A_OSVersion = "WIN_XP" ? 0xFFF : 0xFFFF)
    static PROCESS_ALL_ACCESS          := STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | OSVERSION

    local tPtr := pPtr := nTTL := 0, PList := ""
    if !(DllCall("wtsapi32.dll\WTSEnumerateProcesses", "Ptr", 0, "Int", 0, "Int", 1, "PtrP", pPtr, "PtrP", nTTL))
        return "", DllCall("kernel32.dll\SetLastError", "UInt", -1)

    tPtr := pPtr
    loop % (nTTL)
    {
        if (InStr(PList := StrGet(NumGet(tPtr + 8)), proc))
        {
            PID := NumGet(tPtr + 4, "UInt")
            if !(hProcess := DllCall("kernel32.dll\OpenProcess", "UInt", PROCESS_ALL_ACCESS, "UInt", FALSE, "UInt", PID, "Ptr"))
                return DllCall("kernel32.dll\GetLastError")
            if !(DllCall("kernel32.dll\TerminateProcess", "Ptr", hProcess, "UInt", 0))
                return DllCall("kernel32.dll\GetLastError")
            if !(DllCall("kernel32.dll\CloseHandle", "Ptr", hProcess))
                return DllCall("kernel32.dll\GetLastError")
        }
        tPtr += (A_PtrSize = 4 ? 16 : 24)
    }
    DllCall("wtsapi32.dll\WTSFreeMemory", "Ptr", pPtr)

    return "", DllCall("kernel32.dll\SetLastError", "UInt", nTTL)
}
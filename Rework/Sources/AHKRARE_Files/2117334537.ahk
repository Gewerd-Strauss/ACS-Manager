GetThreadStartAddr(ProcessID) {                                                                     	;-- returns start adresses from all threads of a process
    hModule := DllCall("LoadLibrary", "str", "ntdll.dll", "uptr")

    if !(hSnapshot := DllCall("CreateToolhelp32Snapshot", "uint", 0x4, "uint", ProcessID))
        return "Error in CreateToolhelp32Snapshot"

    NumPut(VarSetCapacity(THREADENTRY32, 28, 0), THREADENTRY32, "uint")
    if !(DllCall("Thread32First", "ptr", hSnapshot, "ptr", &THREADENTRY32))
        return "Error in Thread32First", DllCall("CloseHandle", "ptr", hSnapshot)

    Addr := {}, cnt := 1
    while (DllCall("Thread32Next", "ptr", hSnapshot, "ptr", &THREADENTRY32)) {
        if (NumGet(THREADENTRY32, 12, "uint") = ProcessID) {
            hThread := DllCall("OpenThread", "uint", 0x0040, "int", 0, "uint", NumGet(THREADENTRY32, 8, "uint"), "ptr")
            if (DllCall("ntdll\NtQueryInformationThread", "ptr", hThread, "uint", 9, "ptr*", ThreadStartAddr, "uint", A_PtrSize, "uint*", 0) != 0)
                return "Error in NtQueryInformationThread", DllCall("CloseHandle", "ptr", hThread) && DllCall("FreeLibrary", "ptr", hModule)
            Addr[cnt, "StartAddr"] := Format("{:#016x}", ThreadStartAddr)
            Addr[cnt, "ThreadID"]  := NumGet(THREADENTRY32, 8, "uint")
            DllCall("CloseHandle", "ptr", hThread), cnt++
        }
    }

    return Addr, DllCall("CloseHandle", "ptr", hSnapshot) && DllCall("FreeLibrary", "ptr", hModule)
}
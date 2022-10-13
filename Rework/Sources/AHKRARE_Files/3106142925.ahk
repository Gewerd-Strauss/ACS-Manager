InjectDll(pid,dllpath)  {                                                                                                 	;-- injects a dll to a running process (ahkdll??)

    FileGetSize, size, %dllpath%
    file := FileOpen(dllpath, "r")
    file.RawRead(dllFile, size)

    pHandle := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", false, "UInt", pid)

    pLibRemote := DllCall("VirtualAllocEx", "Uint", pHandle, "Uint", 0, "Uint", size, "Uint", 0x1000, "Uint", 4)

    VarSetCapacity(result,4)
    DllCall("WriteProcessMemory","Uint",pHandle,"Uint",pLibRemote,"Uint",&dllFile,"Uint",size,"Uint",&result)

    LoadLibraryAdd := DllCall("GetProcAddress", "Uint", DllCall("GetModuleHandle", "str", "kernel32.dll"),"AStr", "LoadLibraryA")

    hThrd := DllCall("CreateRemoteThread", "Uint", pHandle, "Uint", 0, "Uint", 0, "Uint", LoadLibraryAdd, "Uint", pLibRemote, "Uint", 0, "Uint", 0)

    DllCall("VirtualFreeEx","Uint",hProcess,"Uint",pLibRemote,"Uint",0,"Uint",32768)

    DllCall("CloseHandle", "Uint", hThrd)
    DllCall("CloseHandle", "Uint", pHandle)
    Return True
}
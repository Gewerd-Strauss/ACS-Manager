ControlGetTabs(Control, WinTitle="", WinText="")
{
    static TCM_GETITEMCOUNT := 0x1304
         , TCM_GETITEM := A_IsUnicode ? 0x133C : 0x1305
         , TCIF_TEXT := 1
         , MAX_TEXT_LENGTH := 260
         , MAX_TEXT_SIZE := MAX_TEXT_LENGTH * (A_IsUnicode ? 2 : 1)

    static PROCESS_VM_OPERATION := 0x8
         , PROCESS_VM_READ := 0x10
         , PROCESS_VM_WRITE := 0x20
         , READ_WRITE_ACCESS := PROCESS_VM_READ |PROCESS_VM_WRITE |PROCESS_VM_OPERATION
         , PROCESS_QUERY_INFORMATION := 0x400
         , MEM_COMMIT := 0x1000
         , MEM_RELEASE := 0x8000
         , PAGE_READWRITE := 4

    if Control is not integer
    {
        ControlGet Control, Hwnd,, %Control%, %WinTitle%, %WinText%
        if ErrorLevel
            return
    }
    
    WinGet pid, PID, ahk_id %Control%

    ; Open the process for read/write and query info.
    hproc := DllCall("OpenProcess", "uint", READ_WRITE_ACCESS |PROCESS_QUERY_INFORMATION
                   , "int", false, "uint", pid, "ptr")
    if !hproc
        return
    
    ; Should we use the 32-bit struct or the 64-bit struct?
    if A_Is64bitOS
        try DllCall("IsWow64Process", "ptr", hproc, "int*", is32bit := true)
    else
        is32bit := true
    RPtrSize := is32bit ? 4 : 8
    TCITEM_SIZE := 16 + RPtrSize*3
    
    ; Allocate a buffer in the (presumably) remote process.
    remote_item := DllCall("VirtualAllocEx", "ptr", hproc, "ptr", 0
                         , "uptr", TCITEM_SIZE + MAX_TEXT_SIZE
                         , "uint", MEM_COMMIT, "uint", PAGE_READWRITE, "ptr")
    remote_text := remote_item + TCITEM_SIZE
    
    ; Prepare the TCITEM structure locally.
    VarSetCapacity(local_item, TCITEM_SIZE, 0)
    NumPut(TCIF_TEXT,       local_item, 0, "uint")
    NumPut(remote_text,     local_item, 8 + RPtrSize)
    NumPut(MAX_TEXT_LENGTH, local_item, 8 + RPtrSize*2, "int")
    
    ; Prepare the local text buffer.
    VarSetCapacity(local_text, MAX_TEXT_SIZE)
    
    ; Write the local structure into the remote buffer.
    DllCall("WriteProcessMemory", "ptr", hproc, "ptr", remote_item
          , "ptr", &local_item, "uptr", TCITEM_SIZE, "ptr", 0)
    
    tabs := []
    
    SendMessage TCM_GETITEMCOUNT,,,, ahk_id %Control%
    Loop % (ErrorLevel=1) ? ErrorLevel : 0
    {
        ; Retrieve the item text.
        SendMessage TCM_GETITEM, A_Index-1, remote_item,, ahk_id %Control%
        if (ErrorLevel = 1) ; Success
            DllCall("ReadProcessMemory", "ptr", hproc, "ptr", remote_text
                  , "ptr", &local_text, "uptr", MAX_TEXT_SIZE, "ptr", 0)
        else
            local_text := ""
        
        ; Store the value even on failure:
        tabs[A_Index] := local_text
    }
    
    ; Release the remote memory and handle.
    DllCall("VirtualFreeEx", "ptr", hproc, "ptr", remote_item
          , "uptr", 0, "uint", MEM_RELEASE)
    DllCall("CloseHandle", "ptr", hproc)
    
    return tabs
}
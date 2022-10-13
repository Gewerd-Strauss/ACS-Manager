FileToClipboard(PathToCopy) {																		;-- a second way to copying the path to clipboard
    ; Expand to full paths:
    Loop, Parse, PathToCopy, `n, `r
        Loop, %A_LoopField%, 1
            temp_list .= A_LoopFileLongPath "`n"
    PathToCopy := SubStr(temp_list, 1, -1)

    ; Allocate some movable memory to put on the clipboard.
    ; This will hold a DROPFILES struct and a null-terminated list of
    ; null-terminated strings.
    ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
    hPath := DllCall("GlobalAlloc","uint",0x42,"uint",StrLen(PathToCopy)+22)

    ; Lock the moveable memory, retrieving a pointer to it.
    pPath := DllCall("GlobalLock","uint",hPath)

/
    pPath += 20
    ; Copy the list of files into moveable memory.
    Loop, Parse, PathToCopy, `n, `r
    {
        DllCall("lstrcpy","uint",pPath+0,"str",A_LoopField)
        pPath += StrLen(A_LoopField)+1
    }

    ; Unlock the moveable memory.
    DllCall("GlobalUnlock","uint",hPath)

    DllCall("OpenClipboard","uint",0)
    ; Empty the clipboard, otherwise SetClipboardData may fail.
    DllCall("EmptyClipboard")
    ; Place the data on the clipboard. CF_
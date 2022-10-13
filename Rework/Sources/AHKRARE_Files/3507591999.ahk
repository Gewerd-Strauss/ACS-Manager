FileToClipboard(PathToCopy) {																		;-- copying the path to clipboard

	;https://autohotkey.com/board/topic/23162-how-to-copy-a-file-to-the-clipboard/
    ; Expand to full path:
    Loop, %PathToCopy%, 1
        PathToCopy := A_LoopFileLongPath

    ; Allocate some movable memory to put on the clipboard.
    ; This will hold a DROPFILES struct, the string, and an (extra) null terminator
    ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
    hPath := DllCall("GlobalAlloc","uint",0x42,"uint",StrLen(PathToCopy)+22)

    ; Lock the moveable memory, retrieving a pointer to it.
    pPath := DllCall("GlobalLock","uint",hPath)

    NumPut(20, pPath+0) ; DROPFILES.pFiles = offset of file list

    ; Copy the string into moveable memory.
    DllCall("lstrcpy","uint",pPath+20,"str",PathToCopy)

    ; Unlock the moveable memory.
    DllCall("GlobalUnlock","uint",hPath)

    DllCall("OpenClipboard","uint",0)
    ; Empty the clipboard, otherwise SetClipboardData may fail.
    DllCall("EmptyClipboard")
    ; Place the data on the clipboard. CF_HDROP=0xF
    DllCall("SetClipboardData","uint",0xF,"uint",hPath)
    DllCall("CloseClipboard")
}
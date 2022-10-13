ImageToClipboard(Filename) {																		;-- Copies image data from file to the clipboard. (first of three approaches)

	;https://autohotkey.com/board/topic/23162-how-to-copy-a-file-to-the-clipboard/
    hbm := DllCall("LoadImage","uint",0,"str",Filename,"uint",0,"int",0,"int",0,"uint",0x10)
    if !hbm
        return
    DllCall("OpenClipboard","uint",0)
    DllCall("EmptyClipboard")
    ; Place the data on the clipboard. CF_BITMAP=0x2
    if ! DllCall("SetClipboardData","uint",0x2,"uint",hbm)
        DllCall("DeleteObject","uint",hbm)
    DllCall("CloseClipboard")
}
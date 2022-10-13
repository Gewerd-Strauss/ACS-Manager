Gdip_ImageToClipboard(Filename) {																;-- Copies image data from file to the clipboard. (second approach)

	;https://autohotkey.com/board/topic/23162-how-to-copy-a-file-to-the-clipboard/
    pBitmap := Gdip_CreateBitmapFromFile(Filename)
    if !pBitmap
        return
    hbm := Gdip_CreateHBITMAPFromBitmap(pBitmap)
    Gdip_DisposeImage(pBitmap)
    if !hbm
        return
;     Gui, Add, Picture, hwndpic W800 H600 0xE
;     SendMessage, 0x172, 0, hbm,, ahk_id %pic%
;     Gui, Show
    DllCall("OpenClipboard","uint",0)
    DllCall("EmptyClipboard")
    ; Place the data on the clipboard. CF_BITMAP=0x2
    if ! DllCall("SetClipboardData","uint",0x2,"uint",hbm)
        DllCall("DeleteObject","uint",hbm)
    DllCall("CloseClipboard")
}
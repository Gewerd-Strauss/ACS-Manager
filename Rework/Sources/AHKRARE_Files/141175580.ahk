Gdip_ImageToClipboard(Filename) {																;-- Copies image data from file to the clipboard. (third approach)

    pBitmap := Gdip_CreateBitmapFromFile(Filename)
    if !pBitmap
        return
    hbm := Gdip_CreateHBITMAPFromBitmap(pBitmap)
    Gdip_DisposeImage(pBitmap)
    if !hbm
        return
    if hdc := DllCall("CreateCompatibleDC","uint",0)
    {
        ; Get BITMAPINFO.
        VarSetCapacity(bmi,40,0), NumPut(40,bmi)
        DllCall("GetDIBits","uint",hdc,"uint",hbm,"uint",0
             ,"uint",0,"uint",0,"uint",&bmi,"uint",0)
        ; GetDIBits seems to screw up and give the image the BI_BITFIELDS
        ; (i.e. colour-indexed) compression type when it is in fact BI_RGB.
        NumPut(0,bmi,16)
        ; Get bitmap bits.
        if size := NumGet(bmi,20)
        {
            VarSetCapacity(bits,size)
            DllCall("GetDIBits","uint",hdc,"uint",hbm,"uint",0
                ,"uint",NumGet(bmi,8),"uint",&bits,"uint",&bmi,"uint",0)
            ; 0x42 = GMEM_MOVEABLE(0x2) | GMEM_ZEROINIT(0x40)
            hMem := DllCall("GlobalAlloc","uint",0x42,"uint",40+size)
            pMem := DllCall("GlobalLock","uint",hMem)
            DllCall("RtlMoveMemory","uint",pMem,"uint",&bmi,"uint",40)
            DllCall("RtlMoveMemory","uint",pMem+40,"uint",&bits,"uint",size)
            DllCall("GlobalUnlock","uint",hMem)
        }
        DllCall("DeleteDC","uint",hdc)
    }
    if hMem
    {
        DllCall("OpenClipboard","uint",0)
        DllCall("EmptyClipboard")
        ; Place the data on the clipboard. CF_DIB=0x8
        if ! DllCall("SetClipboardData","uint",0x8,"uint",hMem)
            DllCall("GlobalFree","uint",hMem)
        DllCall("CloseClipboard")
    }
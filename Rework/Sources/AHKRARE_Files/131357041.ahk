CreatePatternBrushFrom(hbm, x, y, w, h) {                                                          	;-- as it says

	;found on https://autohotkey.com/board/topic/20588-adding-pictures-to-controls-eg-as-background/page-3

    hbm1 := DllCall("CopyImage","uint",hbm,"uint",0,"int",0,"int",0,"uint",0x2000)

    VarSetCapacity(dib,84,0)
    DllCall("GetObject","uint",hbm1,"int",84,"uint",&dib)
    NumPut(h,NumPut(w,dib,28))
    hbm2 := DllCall("CreateDIBSection","uint",0,"uint",&dib+24,"uint",0,"uint*",0,"uint",0,"uint",0)

    Loop, 2 {
        hdc%A_Index% := DllCall("CreateCompatibleDC","uint",0)
        obm%A_Index% := DllCall("SelectObject","uint",hdc%A_index%,"uint",hbm%A_Index%)
    }

    DllCall("BitBlt"
        ,"uint",hdc2,"int",0,"int",0,"int",w,"int",h    ; destination
        ,"uint",hdc1,"int",x,"int",y                    ; source
        ,"uint",0xCC0020)                               ; operation = SRCCOPY

    Loop, 2 {
        DllCall("SelectObject","uint",hdc%A_Index%,"uint",obm%A_Index%)
        DllCall("DeleteDC","uint",hdc%A_Index%)
    }

    hbr := DllCall("CreatePatternBrush","uint",hbm2)
    DllCall("DeleteObject","uint",hbm2)
    DllCall("DeleteObject","uint",hbm1)
    return hbr
}
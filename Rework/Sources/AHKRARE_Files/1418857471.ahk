ChooseColor(ByRef Color, hOwner := 0) {																	;--		what is this for?
    rgbResult := ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)

    VarSetCapacity(CUSTOM, 64, 0)
    NumPut(VarSetCapacity(CHOOSECOLOR, A_PtrSize * 9, 0), CHOOSECOLOR, 0)
    NumPut(hOwner, CHOOSECOLOR, A_PtrSize)
    NumPut(rgbResult, CHOOSECOLOR, A_PtrSize * 3)
    NumPut(&CUSTOM, CHOOSECOLOR, A_PtrSize * 4) ; COLORREF *lpCustColors
    NumPut(0x103, CHOOSECOLOR, A_PtrSize * 5) ; Flags: CC_ANYCOLOR | CC_RGBINIT | CC_FULLOPEN

    RetVal := DllCall("comdlg32\ChooseColorA", "Str", CHOOSECOLOR)
    If (ErrorLevel != 0 || RetVal == 0) {
        Return False
    }

    rgbResult := NumGet(CHOOSECOLOR, A_PtrSize * 3)
    Color := (rgbResult & 0xFF00) + ((rgbResult & 0xFF0000) >> 16) + ((rgbResult & 0xFF) << 16)
    Color := Format("0x{:06X}", Color)
    Return True
}
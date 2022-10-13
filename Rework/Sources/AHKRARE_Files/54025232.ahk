TaskDialogDirect(Instruction, Content := "", Title := "", CustomButtons := "",   		;-- part of TaskDialog ?
CommonButtons := 0, MainIcon := 0, Flags := 0, Owner := 0x10010, VerificationText := "", ExpandedText := "", FooterText := "", FooterIcon := 0, Width := 0) {
    Static x64 := A_PtrSize == 8, Button := 0, Checked := 0

    If (CustomButtons != "") {
        Buttons := StrSplit(CustomButtons, "|")
        cButtons := Buttons.Length()
        VarSetCapacity(pButtons, 4 * cButtons + A_PtrSize * cButtons, 0)
        Loop %cButtons% {
            iButtonText := &(b%A_Index% := Buttons[A_Index])
            NumPut(100 + A_Index, pButtons, (4 + A_PtrSize) * (A_Index - 1), "Int")
            NumPut(iButtonText, pButtons, (4 + A_PtrSize) * A_Index - A_PtrSize, "Ptr")
        }
    } Else {
        cButtons := 0
        pButtons := 0
    }

    NumPut(VarSetCapacity(TDC, (x64) ? 160 : 96, 0), TDC, 0, "UInt") ; cbSize
    NumPut(Owner, TDC, 4, "Ptr") ; hwndParent
    NumPut(Flags, TDC, (x64) ? 20 : 12, "Int") ; dwFlags
    NumPut(CommonButtons, TDC, (x64) ? 24 : 16, "Int") ; dwCommonButtons
    NumPut(&Title, TDC, (x64) ? 28 : 20, "Ptr") ; pszWindowTit
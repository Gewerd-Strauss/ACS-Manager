GetStatusBarText(hWnd) {																							;--
    SB_Text := ""
    hParentWnd := GetParent(hWnd)

    SendMessage 0x406, 0, 0,, ahk_id %hWnd% ; SB_GETPARTS
    Count := ErrorLevel
    If (Count != "FAIL") {
        Loop %Count% {
            StatusBarGetText PartText, %A_Index%, ahk_id %hParentWnd%
            SB_Text .= PartText . "|"
        }
    }

    Return SubStr(SB_Text, 1, -1)
}
GetTabOrderIndex(hWnd) {																						;--

    hParent := GetAncestor(hWnd)

    WinGet ControlList, ControlListHwnd, ahk_id %hParent%
    Index := 1
    Loop Parse, ControlList, `n
    {
        If (!IsWindowVisible(A_LoopField)) {
            Continue
        }

        WinGet Style, Style, ahk_id %A_LoopField%
        If !(Style & 0x10000) { ; WS_TABSTOP
            Continue
        }

        If (A_LoopField == hWnd) {
            Return Index
        }

        Index++
    }

    Return 0
}
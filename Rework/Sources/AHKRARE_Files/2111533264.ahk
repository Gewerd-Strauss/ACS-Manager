GetExtraStyle(hWnd) {                                                                                             	;-- get Extra Styles from a control

    WinGetClass Class, ahk_id %hWnd%

    If (Class == "SysListView32") {
        Message := 0x1037 ; LVM_GETEXTENDEDLISTVIEWSTYLE
    } Else If (Class == "SysTreeView32") {
        Message := 0x112D ; TVM_GETEXTENDEDSTYLE
    } Else If (Class == "SysTabControl32") {
        Message := 0x1335 ; TCM_GETEXTENDEDSTYLE
    } Else If (Class == "ToolbarWindow32") {
        Message := 0x455 ; TB_GETEXTENDEDSTYLE
    } Else If (Class == "ComboBox" && g_Style & 0x10) {
        Message := 0x409 ; CBEM_GETEXTENDEDSTYLE
    }

    SendMessage %Message%, 0, 0,, ahk_id %hWnd%
    Return Format("0x{:08X}", ErrorLevel)
}
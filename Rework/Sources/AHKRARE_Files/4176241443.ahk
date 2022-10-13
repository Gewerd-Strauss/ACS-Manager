GetWindowIcon(hWnd, Class, TopLevel := False) {														;--

	Static Classes := {0:0
    , "#32770": 3
    , "Button": 4
    , "CheckBox": 5
    , "ComboBox": 6
    , "SysDateTimePick32": 7
    , "Edit": 8
    , "GroupBox": 9
    , "msctls_hotkey32": 10
    , "Icon": 11
    , "SysLink": 12
    , "ListBox": 13
    , "SysListView32": 14
    , "SysMonthCal32": 15
    , "Picture": 16
    , "msctls_progress32": 17
    , "Radio": 18
    , "RebarWindow32": 25
    , "RichEdit": 19
    , "Separator": 20
    , "msctls_trackbar32": 21
    , "msctls_statusbar32": 22
    , "SysTabControl32": 23
    , "Static": 24
    , "ToolbarWindow32": 25
    , "tooltips_class32": 26
    , "SysTreeView32": 27
    , "msctls_updown32": 28
    , "Internet Explorer_Server": 29
    , "Scintilla": 30
    , "ScrollBar": 31
    , "SysHeader32": 32}

    If (Class == "Button") {
        WinGet Style, Style, ahk_id %hWnd%
        Type := Style & 0xF
        If (Type == 7) {
            Class := "GroupBox"
        } Else If (Type ~= "2|3|5|6") {
            Class := "CheckBox"
        } Else If (Type ~= "4|9") {
            Class := "Radio"
        } Else {
            Class := "Button"
        }
    } Else If (Class == "Static") {
        WinGet Style, Style, ahk_id %hWnd%
        Type := Style & 0x1F ; SS_TYPEMASK
        If (Type == 3) {
            Class := "Icon"
        } Else If (Type == 14) {
            Class := "Picture"
        } Else If (Type == 0x10) {
            Class := "Separator"
        } Else {
            Class := "Static"
        }
    } Else If (InStr(Class, "RICHED", True) == 1) {
        Class := "RichEdit" ; RICHEDIT50W
    }

    Icon := Classes[Class]
    If (Icon != "") {
        Return Icon
    }

    SendMessage 0x7F, 2, 0,, ahk_id %hWnd% ; WM_GETICON, ICON_SMALL2
    hIcon := ErrorLevel

    If (hIcon == 0 && TopLevel) {
        WinGet ProcessPath, ProcessPath, ahk_id %hWnd%
        hIcon := GetFileIcon(ProcessPath)
    }

    IconIndex := (hIcon) ? IL_Add(ImageList, "HICON: " . hIcon) : 1
    Return IconIndex
}
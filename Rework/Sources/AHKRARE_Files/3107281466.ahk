SetWindowIcon(hWnd, Filename, Index := 1) {															;--
    Local hIcon := LoadPicture(Filename, "w16 Icon" . Index, ErrorLevel)
    SendMessage 0x80, 0, hIcon,, ahk_id %hWnd% ; WM_SETICON
    Return ErrorLevel
}
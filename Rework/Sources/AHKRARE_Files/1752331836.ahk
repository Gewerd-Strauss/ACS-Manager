ToggleTitleMenuBar(ahkid:=0, bHideTitle:=1, bHideMenuBar:=0) {				         	;-- show or hide Titlemenubar

    if ( ahkid = 0 ) ; must with () wrap
        WinGet, ahkid, ID, A
    ; ToolTip, % "AHKID is: " ahkid, 300, 300,
    if ( bHideTitle = 1 ) {
        WinSet, Style, ^0xC00000, ahk_id %ahkid%     ; titlebar toggle
    }
    if ( bHideMenuBar = 1 ) {
        WinSet, Style, ^0x40000, ahk_id %ahkid%      ; menubar toggle
    }
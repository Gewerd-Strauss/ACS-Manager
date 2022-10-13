LV_ClickRow(HLV, Row) { 																								;-- simulates a left mousebutton click on a specific row in a listview

; just me -> http://www.autohotkey.com/board/topic/86490-click-listview-row/#entry550767
; HLV : ListView's HWND, Row : 1-based row number

VarSetCapacity(RECT, 16, 0)
SendMessage, 0x100E, Row - 1, &RECT, , ahk_id %HLV% ; LVM_GETITEMRECT
POINT := NumGet(RECT, 0, "Short") | (NumGet(RECT, 4, "Short") << 16)
PostMessage, 0x0201, 0, POINT, , ahk_id %HLV% ; WM_LBUTTONDOWN
PostMessage, 0x0202, 0, POINT, , ahk_id %HLV% ; WM_LBUTTONUP
}
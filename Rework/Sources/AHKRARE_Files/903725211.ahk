LV_GetItemText(item_index, sub_index, ctrl_id, win_id) {												;-- read the text from an item in a ListView

; https://autohotkey.com/board/topic/18299-reading-listview-of-another-app/
; code from Tigerite
;const
MAX_TEXT = 260

VarSetCapacity(szText, MAX_TEXT, 0)
VarSetCapacity(szClass, MAX_TEXT, 0)
ControlGet, hListView, Hwnd, , %ctrl_id%, ahk_id %win_id%
DllCall("GetClassName", UInt,hListView, Str,szClass, Int,MAX_TEXT)
if (DllCall("lstrcmpi", Str,szClass, Str,"SysListView32") == 0 || DllCall("lstrcmpi", Str,szClass, Str,"TListView") == 0)
{
LVGet_Text(hListView, item_index, sub_index, szText, MAX_TEXT)
}

return %szText%
}
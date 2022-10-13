Control_GetFont( hwnd ,ByRef Name,ByRef Style,ByRef Size) { 									;-- retrieves the used font of a control
; www.autohotkey.com/forum/viewtopic.php?p=465438#465438
; https://autohotkey.com/board/topic/7984-ahk-functions-incache-cache-list-of-recent-items/page-11
; Mod by nothing
 SendMessage 0x31, 0, 0, , ahk_id %hwnd% ; WM_GETFONT
 IfEqual,ErrorLevel,FAIL, Return
 hFont := Errorlevel, 
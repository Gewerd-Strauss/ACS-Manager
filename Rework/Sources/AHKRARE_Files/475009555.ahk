MsgBoxFont(Fontstring, title, msg) {                                                                           	;-- style your MsgBox with with your prefered font
; https://autohotkey.com/board/topic/21003-function-createfont/
hFont := CreateFont("s14 italic, Courier New")
	SetTimer, OnTimer, -30
	MsgBox, , %title%, %msg%

return

OnTimer:
	ControlGet, h, HWND, , Static1, My MsgBox
	SendMessage, 0x30, %hFont%, 1,, ahk_id %h%  ;WM_SETFONT = 0x30
return
}
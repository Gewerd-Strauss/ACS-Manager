ControlGetClassNN(hWndWindow,hWndControl) {													;-- with loop

	; https://autohotkey.com/board/topic/45627-function-control-getclassnn-get-a-control-classnn/
	DetectHiddenWindows, On
	WinGet, ClassNNList, ControlList, ahk_id %hWndWindow%
	Loop, PARSE, ClassNNList, `n
	{
		ControlGet, hwnd, hwnd,,%A_LoopField%,ahk_id %hWndWindow%
		if (hWnd = hWndControl)
			return A_LoopField
	}
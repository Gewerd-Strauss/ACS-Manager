ShowSurface() {                                                                                                   	;-- subfunction for CreateSurface
	WinGet, active_win, ID, A
	Gui DrawSurface:Show
	WinActivate, ahk_id %active_win%
}
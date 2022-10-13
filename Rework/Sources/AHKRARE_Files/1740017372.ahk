Control_GetClassNN( hWnd, hCtrl ) {  																		;-- no-loop

	; SKAN: www.autohotkey.com/forum/viewtopic.php?t=49471
	 WinGet, CH, ControlListHwnd, ahk_id %hWnd%
	 WinGet, CN, ControlList, ahk_id %hWnd%
	 LF:= "`n",  CH:= LF CH LF, CN:= LF CN LF,  S:= SubStr( CH, 1, InStr( CH, LF hCtrl LF ) )
	 StringReplace, S, S,`n,`n, UseErrorLevel
	 StringGetPos, P, CN, `n, L%ErrorLevel%
	 Return SubStr( CN, P+2, InStr( CN, LF, 0, P+2 ) -P-2 )
}
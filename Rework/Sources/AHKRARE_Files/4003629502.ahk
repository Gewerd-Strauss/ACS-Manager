getProcessBaseAddress(WindowTitle, MatchMode=3)	{                                            	;-- gives a pointer to the base address of a process for further memory reading

	;-- https://autohotkey.com/boards/viewtopic.php?t=9016
	;--WindowTitle can be anything ahk_exe ahk_class etc
	mode :=  A_TitleMatchMode
	SetTitleMatchMode, %MatchMode%	;mode 3 is an exact match
	WinGet, hWnd, ID, %WindowTitle%
	; AHK32Bit A_PtrSize = 4 | AHK64Bit - 8 bytes
	BaseAddress := DllCall(A_PtrSize = 4
		? "GetWindowLong"
		: "GetWindowLongPtr", "Uint", hWnd, "Uint", -6)
	SetTitleMatchMode, %mode%	; In case executed in autoexec

	return BaseAddress
}
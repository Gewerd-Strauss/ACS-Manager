SendToAHK(String, WinString) {                                                                                  	;-- Sends strings by using a hidden gui between AHK scripts
	/*                              	DESCRIPTION

		a function by DJAnonimo: posted on https://autohotkey.com/boards/viewtopic.php?f=6&t=45965
		with a bit modification by Ixiko

		added 'WinString' option to handle different windows
		you have to paste a string like WinString:="MyGuiWinTitle" or WinString:="ahk_exe MyAHKScript"
		you can paste also WinString:="ahk_id " . MyGuiHwnd

	*/

	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows On
	StringLen := StrLen(String)
	Loop, %StringLen%
	{
	AscNum := Asc(SubStr(String, A_Index, 1))
	if (A_Index = StringLen)
		LastChar := 1
	PostMessage, 0x5555, AscNum, LastChar,,%WinString%
	}
	DetectHiddenWindows %Prev_DetectHiddenWindows%
}
A_DefaultGui() {																										;-- a nice function to have a possibility to get the number of the default gui

	/*                              	DESCRIPTION

			Link: https://autohotkey.com/board/topic/24532-function-a-defaultgui/
			Description: You don't have the way to get the current default gui in AHK. This functions fills that hole.

	*/
	if A_Gui !=
		return A_GUI

	Gui, +LastFound
	m := DllCall( "RegisterWindowMessage", Str, "GETDEFGUI")
	OnMessage(m, "A_DefaultGui")
	res := DllCall("SendMessageW", "uint",  WinExist(), "uint", m, "uint", 0, "uint", 0)		;use A for Ansi and W for Unicode
	OnMessage(m, "")
	return res
}
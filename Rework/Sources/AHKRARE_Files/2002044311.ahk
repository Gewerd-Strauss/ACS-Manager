Hotkeys(ByRef Hotkeys) {                                                        		;-- a handy function to show all used hotkeys in script

	/*                              	DESCRIPTION

			Link: https://autohotkey.com/boards/viewtopic.php?t=33437

	*/
if (A_ComputerName = "Computer") {
    FileRead, Script, %A_ScriptFullPath%
}
If (A_ComputerName = "Laptop") {
    FileRead, Script, %A_Scr
ExtractFuncTOuserAHK(data) {                                                     	;-- extract user function and helps to write it to userAhk.api

	; https://autohotkey.com/board/topic/78781-extract-function-declarations-from-ahk-lib-to-scite4ahk/

	
		editor_path := A_ProgramFiles "\Autohotkey\SciTE\SciTE.exe"
		API_path := A_MyDocuments "\Autohotkey\SciTE\user.ahk.api"

		; extract function declarations from clipboard, update clipboard contents
		data := clipboard
		output := ""
		StringReplace, data, data, `r`n, @, All
		if (ErrorLevel) { ; if `r`n missing in the string
			StringReplace, data, data, `n, @, All
			if (ErrorLevel) { ; if both `r`n and `n missing in the string
				MsgBox, 4132, % "Single line in clipboard, Did you copy a single line"
					. "of text to the clipboard?"
				IfMsgBox, No
				{
					MsgBox, 4112, Error, % "End of line character could not be "
						. "determined. Exiting."
					ExitApp
				}
			}
		}

		Loop, Parse, data, @
		{
			; if fn declaration line found, modify line and save line in output
			if (RegExMatch(A_LoopField, "^[a-zA-Z0-9_]* *\([^\)]*\) *\{? *$") )
										; no comments after {
										; this statement will cover most cases
				output .= RegExReplace(A_LoopField, "^([a-zA-Z0-9_]*) *(\([^\)]*\)) *\{? *$", "$1 $2") . "`r`n"
					; add a space between fn name and left bracket so SciTE parser
					; 	would work properly. I.e. fun (), not fun()
					; skip the trailing space and { if they are present
			else if (RegExMatch(A_LoopField, "^[a-zA-Z0-9_]* *\([^\)]*\) *\{? +;.*$") )
										; comments after {
				output .= RegExReplace(A_LoopField, "^([a-zA-Z0-9_]*) *(\([^\)]*\)) *\{? +; *(.*)$", "$1 $2 \n$3") . "`r`n"
		}

		; Sort the output
		Sort, output, U ; remove duplicates, case insinsitive for [a-zA-Z]

		; Inform user if duplicate function names found
		StringReplace, output, output, `r`n, @, All
		oldLine := ""
		Loop, Parse, output, @
		{
			line := A_LoopField
			line1 := "", oldline1 := ""
			StringSplit, line, line, `(
			StringSplit, oldLine, oldLine, `(
			if (line1 = oldLine1) { ; case insensitive
				MsgBox, 64, % "Duplicate function names found., Duplicate function"
					. " names found. User attention required."
				break
			}
			oldLine := line
		}
		StringReplace, output, output, @, `r`n, All

		clipboard := output

		; open *.api file and exit
		Run, "%editor_path%" "%API_path%"
		ToolTip, Done
		Sleep 1500
		ToolTip

return
}
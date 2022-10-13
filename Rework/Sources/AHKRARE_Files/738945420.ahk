PIDfromAnyID( anyID="" ) {                                                                                        	;-- for easy retreaving of process ID's (PID)
  Process, Exist, %anyID%
  If (ErrorLevel), Return ErrorLevel					;IfGreater, ErrorLevel, 0, Return ErrorLevel   	;<-comment line is the original: it uses an old syntax, not recommend for newer scripts

  DetectHiddenWindows, % SubStr( ( ADHW := A_DetectHiddenWindows ) . "On", -1 )
  SetTitleMatchMode,   % SubStr( ( ATMM := A_TitleMatchMode )   . "RegEx", -4 )

  WinGet, PID, PID, ahk_id %anyID%
  If (!PID)                                                        	;IfEqual, PID,, WinGet, PID, PID, %anyID% 	;<-comment line is the original: it uses an old syntax, not recommend for newer scripts
		WinGet, PID, PID, %anyID%

  DetectHiddenWindows, %ADHW%
  SetTitleMatchMode, %ATMM%

Return PID ? PID : 0
}
PIDfromAnyID( anyID="" ) {                                                                                        	;-- get PID from any ID
	  Process, Exist, %anyID%
	  IfGreater, ErrorLevel, 0, Return ErrorLevel
	  DetectHiddenWindows, % SubStr( ( ADHW := A_DetectHiddenWindows ) . "On", -1 )
	  SetTitleMatchMode,   % SubStr( ( ATMM := A_TitleMatchMode )   . "RegEx", -4 )
	  WinGet, PID, PID, ahk_id %anyID%
	  IfEqual, PID,, WinGet, PID, PID, %anyID%
	  DetectHiddenWindows, %ADHW%
	  SetTitleMatchMode, %ATMM%

Return PID ? PID : 0
}
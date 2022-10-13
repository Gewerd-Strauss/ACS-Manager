SetTaskbarProgress(pct, state="", hwnd="") { 													    	;-- accesses Windows 7's ability to display a progress bar behind a taskbar button.

	; https://autohotkey.com/board/topic/46860-windows-7-settaskbarprogress/ - from Lexikos
	; edited version of Lexikos' SetTaskbarProgress() function to work with Unicode 64bit, Unicode 32bit, Ansi 32bit, and Basic/Classic (1.0.48.5)
	; SetTaskbarProgress  -  Requires Windows 7.
	;
	; pct    -  A number between 0 and 100 or a state value (see below).
	; state  -  "N" (normal), "P" (paused), "E" (error) or "I" (indeterminate).
	;           If omitted (and pct is a number), the state is not changed.
	; hwnd   -  The ID of the window which owns the taskbar button.
	;           If omitted, the Last Found Window is used.

	/*		EXAMPLE

		Gui, Font, s15
		Gui, Add, Text,, % "This GUI should show a progress bar on its taskbar button.`n"
						 . "It will demonstrate the four different progress states:`n"
						 . "(N)ormal, (P)aused, (E)rror and (I)ndeterminate."
		Gui, Show        ; Show the window and taskbar button.
		Gui, +LastFound  ; SetTaskbarProgress will use this window.
		Loop
		{
			progress_states=NPE
			Loop, Parse, progress_states
			{
				SetTaskbarProgress(0, A_LoopField)
				Loop 50 {
					SetTaskbarProgress(A_Index*2)
					Sleep 50
				}
				Sleep 1000
				Loop 50 {
					SetTaskbarProgress(100-A_Index*2)
					Sleep 50
				}
				SetTaskbarProgress(0)
				Sleep 1000
			}
			SetTaskbarProgress("I")
			Sleep 4000
		}
		GuiClose:
		GuiEscape:
		ExitApp
	*/

    static tbl, s0:=0, sI:=1, sN:=2, sE:=4, sP:=8
	 if !tbl
	  Try tbl := ComObjCreate("{56FDF344-FD6D-11d0-958A-006097C9A090}"
							, "{ea1afb91-9e28-4b86-90e9-9e9f8a5eefaf}")
	  Catch
	   Return 0
	 If hwnd =
	  hwnd := WinExist()
	 If pct is not number
	  state := pct, pct := ""
	 Else If (pct = 0 && state="")
	  state := 0, pct := ""
	 If state in 0,I,N,E,P
	  DllCall(NumGet(NumGet(tbl+0)+10*A_PtrSize), "uint", tbl, "uint", hwnd, "uint", s%state%)
	 If pct !=
	  DllCall(NumGet(NumGet(tbl+0)+9*A_PtrSize), "uint", tbl, "uint", hwnd, "int64", pct*10, "int64", 1000)
	Return 1
}
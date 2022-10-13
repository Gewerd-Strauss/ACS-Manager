GetCallStack(Report := 0) {                                                                 	;-- retrieves the current callstack
   Local Stack := [], StackIndex := 0, E, M
   While (E := Exception("", --StackIndex)).What <> StackIndex {
      Stack[A_Index] := {Called: E.What, Caller: "Auto-Exec/Event", Line: E.Line, File: E.File}
      If (A_Index > 1)
         Stack[A_Index - 1].Caller := E.What
   }
   If (Report & 1) { ; MsgBox
      M := ""
      For Each, E In Stack
         M .= E.Called . "  <<  called by " . E.Caller . " at line " . E.Line . " of " . E.File . "`r`n"
      MsgBox, 0, Callstack, % M
   }
   If (Report & 2) ; OutputDebug
      For Each, E In Stack
         OutputDebug, %  "`r`n" . E.Called . " called by " . E.Caller . " at line " . E.Line . " of " . E.File
   Return Stack
}
Start(Target, Minimal = false, Title = "") { 											                                                                    	;-- Start programs or scripts easier
   cPID = -1
   if Minimal
      Run %ComSpec% /c "%Target%", A_WorkingDir, Min UseErrorLevel, cPID
   else
      Run %ComSpec% /c "%Target%", A_WorkingDir, UseErrorLevel, cPID
   if ErrorLevel = 0
   {
      if (Title <> "")
      {
         WinWait ahk_pid %cPID%,,,2
         WinSetTitle, %Title%
      }
      return, 0
   }
   else
      return, -1
}
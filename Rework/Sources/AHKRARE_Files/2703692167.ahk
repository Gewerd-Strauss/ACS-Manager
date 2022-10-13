WinWaitForMinimized(ByRef winID, timeOut = 1000) {												;-- waits until the window is minimized

   iterations := timeOut/10
   loop,%iterations%
   {
      WinGet,winMinMax,MinMax,ahk_id %winID%
      if (winMinMax = -1)
         break
      sleep 10
   }
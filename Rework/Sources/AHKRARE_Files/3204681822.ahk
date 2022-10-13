ShowTrayBalloon(TipTitle = "", TipText = "", ShowTime = 5000, TipType = 1) {					;--

   global cfg

   if (not cfg.ShowBalloons)
      return, 0
   gosub, RemoveTrayTip
   if (TipText <> "")
   {
      Title := (TipTitle <> "") ? TipTitle : ProgramName
      TrayTip, %Title%, %TipText%, 10, %TipType%+16
      SetTimer, RemoveTrayTip, %ShowTime%
   }
   else
   {
      gosub, RemoveTrayTip
      return, 0
   }
   return, 0

   RemoveTrayTip:
      SetTimer, RemoveTrayTip, Off
      TrayTip
   return
}
WinActivateEx(WinTitle, WinText="", Seconds=30, Keys="", OnlyIfExist = false) {		;-- Activate a Window, with extra Error Checking and More Features

   ;   SetTitleMatchMode Regex
   ; Kill Vista Thumbnails.  These hang around a lot, and they're never what you want to activate.

   if (Seconds == "")
      Seconds := 30

   if (OnlyIfExist && !WinExist(WinTitle))
      return false

   WinWait %WinTitle%, %WinText%, %Seconds%
   AssertNoError(ProcList("WinActivateEx - Waiting", WinTitle, WinText, Seconds))

   WinShow %WinTitle%
   WinActivate %WinTitle%, %WinText%
   WinWaitActive %WinTitle%, %WinText%
   AssertNoError(ProcList("WinActivateEx - WaitActive", WinTitle, WinText, Seconds))

   if (Keys)
      SendInput %Keys%

   return true
}
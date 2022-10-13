ControlGetTextExt(hControl, hWinTitle)  {                                                       			;-- 3 different variants are tried to determine the text of a control

	/*                                                   	DESCRIPTION

				;Replaces the AHK function ControlGetText, which sometimes does not work.
				; cf.: http://de.autohotkey.com/forum/viewtopic.php?t=7366&postdays=0&postorder=asc&start=0
				;SYNTAX: VText := ControlGetTextExt("Static8", "StarMoney Business 4.0")
				;SYNTAX: Erg := ControlGetTextExt("#327701", "Date and Time")

	*/

	DetectHiddenText, on
   ; 1. Step. Normal ControlGetText with AHK:
   ControlGetText, ControlText, %hControl%, %hWinTitle%
   If (StrLen(Controltext)=0) {
      ; 2. Step. DllCall with "GetWindowText":
      ControlGet, ControlHWND, Hwnd,, %hControl%, %hWinTitle%
      ControlTextSize = 512
      VarSetCapacity(ControlText, ControlTextSize)
      Result := DllCall("GetWindowText", "uint", ControlHWND, "str", ControlText, "int", ControlTextSize)
      If (StrLen(Controltext)=0)
         ; 3. Step. SendMessage with WM_GETTEXT (0xD):
         SendMessage, 0xD, ControlTextSize, &ControlText, %hControl%, %hWinTitle%
   }
   Return ControlText
}
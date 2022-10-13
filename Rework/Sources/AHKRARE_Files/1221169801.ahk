hk(keyboard:=false, mouse:=0, message:="", timeout:=3, displayonce:=false,screen:=false, screencolor:="blue") ;-- Disable all keyboard buttons
{ 
	; retrieved 20.09.2021 20:56:58 at https://www.autohotkey.com/boards/viewtopic.php?t=33925
	; slightly modified to return the current locking state by Gewerd Strauss
	;keyboard (true/false).......................... disable/enable keyboard
	;mouse=1........................................ disable all mouse buttons
	;mouse=2........................................ disable right mouse button only
	;msessage....................................... display a message
	;timeout........................................ how long to display the message in sec
	;displayonce (true/false) ...................... display a message only once or always
	;hide the screen (true/false)................... hide or show everything
	;ScreenColor ................................... RGB Hex background color for the hiding GUI 
	
	
	static AllKeys, z, d, kb, ms, sc
	if keyboard
		bIsKeyboardBlocked:=true
	else
		bIsKeyboardBlocked:=false
	if (mouse!=0)
		bIsMouseBlocked:=true
	else
		bIsMouseBlocked:=false
	z:=message, d:=displayonce, kb:=keyboard, ms:=mouse, sc:=screen
	
	For k,v in AllKeys {
		Hotkey, *%v%, Block_Input, off         ; initialisation
	}
	if !AllKeys {
		s := "||NumpadEnter|Home|End|PgUp|PgDn|Left|Right|Up|Down|Del|Ins|"
		Loop, 254
			k := GetKeyName(Format("VK{:0X}", A_Index))
       , s .= InStr(s, "|" k "|") ? "" : k "|"
		For k,v in {Control:"Ctrl",Escape:"Esc"}
			AllKeys := StrReplace(s, k, v)
		AllKeys := StrSplit(Trim(AllKeys, "|"), "|")
	}
   ;------------------
	lMouseBlocked:=false
	if (mouse!=2)  ; if mouse=1 disable right and left mouse buttons  if mouse=0 don't disable mouse buttons
	{
		For k,v in AllKeys {
			IsMouseButton := Instr(v, "Wheel") || Instr(v, "Button")
			Hotkey, *%v%, Block_Input, % (keyboard && !IsMouseButton) || (mouse && IsMouseButton) ? "On" : "Off"
			;m((mouse && iSMouseButton),(keyboard && !IsMouseButton))
		}
	}
	if (mouse=2)   ;disable right mouse button (but not left mouse)
	{                
		ExcludeKeys:="LButton"
		For k,v in AllKeys {
			IsMouseButton := Instr(v, "Wheel") || Instr(v, "Button")
			if v not in %ExcludeKeys%
				Hotkey, *%v%, Block_Input, % (keyboard && !IsMouseButton) || (mouse && IsMouseButton) ? "On" : "Off"
		}
	}
	if d
	{
		if (z != "") {
			Progress, +AlwaysOnTop W2000 H43 b zh0 cwFF0000 FM20 CTFFFFFF,, %z%
			SetTimer, TimeoutTimer, % -timeout*1000
		}
		else
			Progress, Off
     }
	Block_Input:
	if (d!=1)
	{
		if (z != "") {
			if (kb || ms)
				Progress, W2000 H43 b zh0 cwFF0000 FM20 CTFFFFFF,, %z%
			else
				Progress, W2000 H43 b zh0 cw009F00 FM20 CTFFFFFF,, %z%
			SetTimer, TimeoutTimer, % -timeout*1000
		}
		else
			Progress, Off
     }
	
	
	if (sc=1)
	{ 
		Gui screen:  -Caption
		Gui screen: Color,  % screencolor
		Gui screen: Show, x0 y0 h74 w%a_screenwidth% h%a_screenheight%, New GUI Window
	}
	else
		gui screen: Hide
	
	
	return [bIsKeyboardBlocked,bIsMouseBlocked]
	TimeoutTimer:
	Progress, Off
	Return
}
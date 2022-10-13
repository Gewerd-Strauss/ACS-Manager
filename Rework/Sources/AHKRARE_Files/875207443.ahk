SureControlCheck(CName, WinTitle, WinText="") { 													;-- Window Activation + ControlDelay to -1 + Check if the control is really checked now
	;by Ixiko 2018
	;BlockInput, On
		Critical
		WinActivate, %WTitle%, %WinText%
			WinWaitActive, %WTitle%, %WinText%, 1

		SetControlDelay -1
			Loop {
				Control, Check, , %CName%, %WinTitle%, %WinText%
					sleep, 10
				ControlGet, isornot, checked, ,  %CName%, %WinTitle%, %WinText%
			} until (isornot = 1)

		SetControlDelay 20

	;BlockInput, Off

	return ErrorLevel
}
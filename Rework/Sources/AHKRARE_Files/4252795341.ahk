SureControlClick(CName, WinTitle, WinText="") { 														;--Window Activation + ControlDelay to -1 + checked if control received the click
		;by Ixiko 2018
		Critical
		WinActivate, %WTitle%, %WinText%
			WinWaitActive, %WTitle%, %WinText%, 3

		SetControlDelay -1
			ControlClick, %CName%, %WinTitle%, %WinText%,,, NA		;If the click does not work then he tries a little differently
				If ErrorLevel
					ControlClick, %CName%, %WinTitle%, %WinText%

		SetControlDelay 20
	return ErrorLevel
}
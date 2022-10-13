ReleaseModifiers(Beep = 1, CheckIfUserPerformingAction = 0,    ;-- helps to solve the Hotkey stuck problem
AdditionalKeys = ""	, timeout := "") {

	/*						Description

				To have maximum reliability you really need to loop through all of the modifier and only proceed with the actions once none of them are down.
				It checks the modifiers keys and if one is down it will continually re-check them every 5ms  - when they are all released it will then wait 35ms and
				recheck them again (this second re-check is only required for this game) - if none are down it will return otherwise it keeps going (unless a 'timeout' period was specified).

				Also as pointed out some people have had success sending modifer up keystrokes like  {LWin up} -
				but I think this is hit and miss for many. Some find using Senevent or Send blind is required to 'unstick' the key.

	*/

	; https://autohotkey.com/board/topic/94091-sometimes-modifyer-keys-always-down/
	 ;timout in ms
	GLOBAL HotkeysZergBurrow
	startTime := A_Tickcount

	startReleaseModifiers:
	count := 0
	firstRun++
	while getkeystate("Ctrl", "P") || getkeystate("Alt", "P")
	|| getkeystate("Shift", "P") || getkeystate("LWin", "P") || getkeystate("RWin", "P")
	||  AdditionalKeys && (ExtraKeysDown := isaKeyPhysicallyDown(AdditionalKeys))  ; ExtraKeysDown should actually return the actual key
	|| (isPerformingAction := CheckIfUserPerformingAction && isUserPerformingAction()) ; have this function last as it can take the longest if lots of units selected
	{
		count++
		if (timeout && A_Tickcount - startTime >= timeout)
			return 1 ; was taking too long
		if (count = 1 && Beep) && !isPerformingAction && !ExtraKeysDown && firstRun = 1	;wont beep if casting or burrow AKA 'extra key' is down
				nothing=	   ;placeholder i dont want to play songs right now                            			;~ SoundPlay, %A_Temp%\ModifierDown.wav
		if ExtraKeysDown
			LastExtraKeyHeldDown := ExtraKeysDown ; as ExtraKeysDown will get blanked in the loop preventing detection in the below if
		else LastExtraKeyHeldDown := ""
		sleep, 5
	}
	if count
	{
		if (LastExtraKeyHeldDown = HotkeysZergBurrow)
			sleep 10 ;as burrow can 'buffer' within sc2
		else sleep, 5	;give time for sc2 to update keystate - it can be a slower than AHK (or it buffers)!
		Goto, startReleaseModifiers
	}
	return
}
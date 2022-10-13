FadeGui(guihwnd, fading_time, inout) {                                                                    	;-- used DllCall to Animate (Fade in/out) a window

	AW_BLEND := 0x00080000
	AW_HIDE  := 0x00010000

	if inout	= "out"
		DllCall("user32\AnimateWindow", "ptr", guihwnd, "uint", fading_time, "uint", AW_BLEND|AW_HIDE)    ; Fade Out
	if inout = "in"
		DllCall("user32\AnimateWindow", "ptr", guihwnd, "uint", fading_time, "uint", AW_BLEND)    ; Fade In

return
}
DisableFadeEffect() {                                                                                                   	;-- disabling fade effect on gui animations
	; SPI_GETCLIENTAREAANIMATION = 0x1042
	DllCall("SystemParametersInfo", "UInt", 0x1042, "UInt", 0, "UInt*", isEnabled, "UInt", 0)

	if isEnabled {
		; SPI_SETCLIENTAREAANIMATION = 0x1043
		DllCall("SystemParametersInfo", "UInt", 0x1043, "UInt", 0, "UInt", 0, "UInt", 0)
		Progress, 10:P100 Hide
		Progress, 10:Off
		DllCall("SystemParametersInfo", "UInt", 0x1043, "UInt", 0, "UInt", 1, "UInt", 0)
	}
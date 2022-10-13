Ansi2Oem(sString) {																		;-- using Ansi2Unicode and Unicode2Ansi functions
	Ansi2Unicode(sString, wString, 0)
	Unicode2Ansi(wString, zString, 1)
	Return zString
}
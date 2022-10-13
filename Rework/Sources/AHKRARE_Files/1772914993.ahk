UTF82Ansi(zString) {                                                                    	;-- using Ansi2Unicode and Unicode2Ansi functions
	Ansi2Unicode(zString, wString, 65001)
	Unicode2Ansi(wString, sString, 0)
	Return sString
}
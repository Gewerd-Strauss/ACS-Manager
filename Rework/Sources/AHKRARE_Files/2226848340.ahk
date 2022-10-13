Ansi2UTF8(sString) {                                                                    	;-- using Ansi2Unicode and Unicode2Ansi functions
	Ansi2Unicode(sString, wString, 0)
	Unicode2Ansi(wString, zString, 65001)
	Return zStri
BGR(RGB) {																									        	;-- BGR() subfunction from CreateBMPGradient()

	RGB = 00000%RGB%
		Return SubStr(RGB,-1) . SubStr(RGB,-3,2) . SubStr(RGB,-5,2)
}
ReceiveFromAHK(wParam, lParam, Msg) {                                                                  	;-- Receiving strings from SendToAHK
	global tempVar
	global receivedVar
		if (Msg = 0x5555)
			{
			tempVar .= Chr(wParam)
			if lParam
                receivedVar := tempVar, tempVar := ""
			}
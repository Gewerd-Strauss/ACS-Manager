FormatSeconds(Secs) {                                                                                        	;-- formats seconds to hours,minutes and seconds -> 12:36:10

	Return SubStr("0" . Secs // 3600, -1) . ":"
        . SubStr("0" . Mod(Secs, 3600) // 60, -1) . ":"
        . SubStr("0" . Mod(Secs, 60), -1)
}
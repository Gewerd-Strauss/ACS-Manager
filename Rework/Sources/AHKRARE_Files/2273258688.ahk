DriveSpace(Drv="", Free=1) { 																                                                                    	;-- retrieves the DriveSpace
	; www.autohotkey.com/forum/viewtopic.php?p=92483#92483
	Drv := Drv . ":\",  VarSetCapacity(SPC, 30, 0), VarSetCapacity(BPS, 30,
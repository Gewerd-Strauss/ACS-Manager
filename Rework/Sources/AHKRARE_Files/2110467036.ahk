parseJSON(txt) {																				;-- Parse Json string to an object

	out := {}
	Loop																				; Go until we say STOP
	{
		ind := A_index															; INDex number for whole array
		ele := strX(txt,"{",n,1, "}",1,1, n)									; Find next ELEment {"label":"value"}
		if (n > strlen(txt)) {
			break																	; STOP when we reach the end
		
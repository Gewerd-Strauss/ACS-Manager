cleancolon(txt) {																				;-- what for? removes on ':' at beginning of a string

	if substr(txt,1,1)=":" {
		txt:=substr(txt,2)
		txt = %txt%
	}
	return txt
}
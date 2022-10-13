cleanlines(ByRef txt) {																		;-- removes all empty lines

	Loop, Parse, txt, `n, `r
	{
		i := A_LoopField
		if !(i){
			continue
		}
		newtxt .= i "`n"
	}
	return newtxt
}
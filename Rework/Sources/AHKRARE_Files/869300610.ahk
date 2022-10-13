RegExSplit(ByRef psText, psRegExPattern, piStartPos:=1) {				;-- split a String by a regular expressin pattern and you will receive an array as a result
	aRet := []
	if (psText != "") 	{

		iStartPos := piStartPos
		while (iPos := RegExMatch(psText, "P)" . psRegExPattern, match, iStartPos)) {

			sFound := ExtractSE(psText, iStartPos, iPos-1)
			aRet.Push(sFound)
			iStartPos := iPos + match
		}
        sFound := ExtractSE(psText, iStartPos)
        aRet.Push(sFound)
	}
	return aRet
}
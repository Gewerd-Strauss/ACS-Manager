RegExSplit(ByRef psText, psRegExPattern, piStartPos:=1) {				;-- split a String by a regular expressin pattern and you will receive an array as a result

	;https://autohotkey.com/board/topic/123708-useful-functions-collection/ - ObiWanKenobi
	;Parameters for RegExSplit:
	;psText                      the text you want to split
	;psRegExPattern      the Regular Expression you want to use for splitting
	;piStartPos               start at this posiiton in psText (optional parameter)
	;function ExtractSE() is a helper-function to extract a string at a specific start and end position.

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
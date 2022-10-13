StrCount(Haystack,Needle) {															;-- a very handy function to count a needle in a Haystack

	; https://github.com/joedf/AEI.ahk/blob/master/AEI.ahk
	StringReplace, Haystack, Haystack, %Needle%, %Needle%, UseErrorLevel
	return ErrorLevel
}
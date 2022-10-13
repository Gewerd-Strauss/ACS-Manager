WrapText(Text, LineLength) {                                                        	;-- basic function to wrap a text-string to a given length
	StringReplace, Text, Text, `r`n, %A_Space%, All
	while (p := RegExMatch(Text, "(.{1," LineLength "})(\s|\R+|$)", Match, p ? p + StrLen(Match) : 1))
		Result .= Match1 ((Match2 = A_Space || Match2 = A_Tab) ? "`n" : Match2)
	return, Result
}
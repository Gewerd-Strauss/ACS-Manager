GetFuncDefs(scriptPath) {                                                                                	;-- get function definitions from a script

	; does not include those with a definition of "()" (no parameters)
	; this is part of  "Insert User Function Definitions -- for Notepad++" from boiler, maybe you need a different output
	;
	defs := ""
	FileRead, rawScript, %scriptPath%

	; remove comment blocks:
	cleanScript := "`n" ; start with `n so RegEx can know a func def is preceded by one even if first line
	blockStart := 0
	Loop, Parse, rawScript, `n, `r
	{
		if blockStart
		{
			if (SubStr(LTrim(A_LoopField), 1, 2) = "*/")
				blockStart := 0
		}
		else
		{
			if (SubStr(LTrim(A_LoopField), 1, 2) = "/*")
				blockStart := 1
			else
				cleanScript .= A_LoopField "`n"
		}
	}

	; get function definitions:
	startPos := 1
	Loop
	{
		; original: if (foundPos := RegExMatch(cleanScript, "\n\s*\K[\w#@$]+\([^\n;]+\)(?=\s*(;[^n]*)*\n*{)", match, startPos))
		if (foundPos := RegExMatch(cleanScript, "U)\n\s*\K[ \t]*(?!(if\(|while\(|for\())([\w#!^+&<>*~$])+\d*\([^)]+\)([\s]|(/\*.*?\*)/|((?<=[\s]);[^\r\n]*?$))*?[\s]*\n*(?=\{)", match, startPos))
		{
			defs .= Trim(RegExReplace(match, "\s*\n\s*$")) " {`n"
			startPos := InStr(cleanScript, "`n",, foundPos) ; start at next line
		}
	} until !foundPos

	return defs
}
PasteWithIndent(clp, ind="Tab", x=1) {											;-- paste string to an editor with your prefered indent key

	;use Tab or Space for example , x how many times you want to have an indent, clp = can contains many lines (lines must liminated through `n)
	ind:= "`{" . ind . " " . x . "`}"

	Loop, Parse, clp, `n
		{
			Send, {Shift Down}{HOME}{Shift Up}
			Send, {Del}
			StringReplace, t, A_LoopField, `n`r, , All
			Send, %ind%%t%				; {ENTER}
		}

return
}
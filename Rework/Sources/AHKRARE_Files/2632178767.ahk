Traceback(actual:=false) {                                                                  	;-- get stack trace
	r := [], i := 0, n := actual ? 0 : A_AhkVersion<"2" ? 1 : 2
	Loop
	{
		e := Exception(".", offset := -(A_Index + n))
		if (e.What == offset)
			break
		r[++i] := { "file": e.file, "line": e.Line, "caller": e.What, "offset": offset + n }
	}
	return r
}
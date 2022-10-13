LineDelete(V, L, R := "", O := "", ByRef M := "") {                            	;-- deletes a specific line or a range of lines from a variable containing one or more lines of text. No use of any loop!
	T := StrSplit(V, "`n").MaxIndex()

	if (L > 0 && L <= T && (O = "" || O = "B"))
	{
		V := StrReplace(V, "`r`n", "`n"), S := "`n" V "`n"
		P := (O = "B") ? InStr(S, "`n",,, L + 1)
		   : InStr(S, "`n",,, L)
		M	:= (R <> "" && R > 0 && O = "" ) 	? SubStr(S, P + 1, InStr(S, "`n",, P, 2 + (R - L)) - P - 1)
			: 	(R <> "" && R < 0 && O = "" )  	? SubStr(S, P + 1, InStr(S, "`n",, P, 3 + (R - L + T)) - P - 1)
			: 	(R <> "" && R > 0 && O = "B")	? SubStr(S, P + 1, InStr(S, "`n",, P, R - L) - P - 1)
			: 	(R <> "" && R < 0 && O = "B")	? SubStr(S, P + 1, InStr(S, "`n",, P, 1 + (R - L + T)) - P - 1)
			: 	SubStr(S, P + 1, InStr(S, "`n",, P, 2) - P - 1)
		X := SubStr(S, 1, P - 1) . SubStr(S, P + StrLen(M) + 1), X := SubStr(X, 2, -1)
	}
	Else if (L < 0 && L >= -T && (O = "" || O = "B"))
	{
		V := StrReplace(V, "`r`n", "`n"), S := "`n" V "`n"
		P := (R <> "" && R < 0 && O = "" ) 	? InStr(S, "`n",,, R + T + 1)
		   : 	(R <> "" && R > 0 && O = "" )  	? InStr(S, "`n",,, R)
		   : 	(R <> "" && R < 0 && O = "B")	? InStr(S, "`n",,, R + T + 2)
		   : 	(R <> "" && R > 0 && O = "B")	? InStr(S, "`n",,, R + 1)
		   : 	InStr(S, "`n",,, L + T + 1)
		M := (R <> "" && R < 0 && O = "" ) 	? SubStr(S, P + 1, InStr(S, "`n",, P, 2 + (L - R)) - P - 1)
		   : 	(R <> "" && R > 0 && O = "" )  	? SubStr(S, P + 1, InStr(S, "`n",, P, 3 + (T - R + L)) - P - 1)
		   : 	(R <> "" && R < 0 && O = "B")	? SubStr(S, P + 1, InStr(S, "`n",, P, (L - R)) - P - 1)
		   : 	(R <> "" && R > 0 && O = "B")	? SubStr(S, P + 1, InStr(S, "`n",, P, 1 + (T - R + L)) - P - 1)
		   : SubStr(S, P + 1, InStr(S, "`n",, P, 2) - P - 1)
		X := SubStr(S, 1, P - 1) . SubStr(S, P + StrLen(M) + 1), X := SubStr(X, 2, -1)
	}

Return X
}
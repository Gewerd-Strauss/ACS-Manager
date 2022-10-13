SplitLine(str, Byref key, ByRef val) {                                              	;-- split string to key and value

	If (p := InStr(str, "=")) {
		key := Trim(SubStr(str, 1, p - 1))
		val := Trim(SubStr(str, p + 1))
		Return True
	}
	Return False
}
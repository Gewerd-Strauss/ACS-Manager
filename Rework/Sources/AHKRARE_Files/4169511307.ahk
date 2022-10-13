AddTrailingBackslash(ptext) {															;-- adds a backslash to the beginning of a string if there is none

	if (SubStr(ptext, 0, 1) <> "\")
		return, ptext . "\"
	return, ptext
}
hexToBinaryBuffer(hexString, byRef buffer) {                                                              	;--

	StringReplace, hexString, hexString, 0x,, All
	StringReplace, hexString, hexString, %A_Space%,, All
	StringReplace, hexString, hexString, %A_Tab%,, All
	if !length := strLen(hexString)
	{
        msgbox nothing was passed to hexToBinaryBuffer
        return 0
	}
	if mod(length, 2)
	{
        msgbox Odd Number of characters passed to hexToBinaryBuffer`nEnsure two digits are used for each byte e.g. 0E
        return 0
	}
	byteCount := length/ 2
	VarSetCapacity(buffer, byteCount)
	loop, % byteCount
        numput("0x" . substr(hexString, 1 + (A_index - 1) * 2, 2), buffer, A_index - 1, "UChar")
	return byteCount
}
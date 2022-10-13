JEE_HexToBinData(vHex, ByRef vSize:="") {										;-- hexadecimal to binary
	vChars := StrLen(vHex)
	;CRYPT_STRING_HEX := 0x4
	;CRYPT_STRING_HEXRAW := 0xC ;(not supported by Windows XP)
	DllCall("crypt32\CryptStringToBinary", Ptr,&vHex, UInt,vChars, UInt,0x4, Ptr,0, UIntP,vSize, Ptr,0, Ptr,0)
	VarSetCapacity(vData, vSize, 0)
	DllCall("crypt32\CryptStringToBinary", Ptr,&vHex, UInt,vChars, UInt,0x4, Ptr,&vData, UIntP,vSize, Ptr,0, Ptr,0)
	return &vData
}
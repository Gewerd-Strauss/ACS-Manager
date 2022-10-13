JEE_BinDataToHex2(vAddr, vSize) {													;-- binary to hexadecimal2
	;CRYPT_STRING_HEXRAW := 0xC ;to return raw hex (not supported by Windows XP)
	DllCall("crypt32\CryptBinaryToString", Ptr,vAddr, UInt,vSize, UInt,0xC, Ptr,0, UIntP,vChars)
	VarSetCapacity(vHex, vChars*2, 0)
	DllCall("crypt32\CryptBinaryToString", Ptr,vAddr, UInt,vSize, UInt,0xC, Str,vHex, UIntP,vChars)
	return vHex
}
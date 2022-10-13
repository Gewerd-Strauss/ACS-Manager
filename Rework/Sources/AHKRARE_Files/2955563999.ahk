JEE_BinDataToHex(vAddr, vSize) {													;-- binary to hexadecimal
	;CRYPT_STRING_HEX := 0x4 ;to return space/CRLF-separated text
	;CRYPT_STRING_HEXRAW := 0xC ;to return raw hex (not supported by Windows XP)
	DllCall("crypt32\CryptBinaryToString", Ptr,vAddr, UInt,vSize, UInt,0x4, Ptr,0, UIntP,vChars)
	VarSetCapacity(vHex, vChars*2, 0)
	DllCall("crypt32\CryptBinaryToString", Ptr,vAddr, UInt,vSize, UInt,0x4, Str,vHex, UIntP,vChars)
	vHex := StrReplace(v
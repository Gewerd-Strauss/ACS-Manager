gcd(a, b) {                                                                    	;-- MCode GCD - Find the greatest common divisor (GCD) of two numbers
	static gcd, x := MCode(gcd, "5589E583E4F083EC10E800000000EB1C8B450C8944240C8B450889C2C1FA1FF77D0C89550C8B44240C894508837D0C000F95C084C075D98B4508C9C3")
	return dllcall(&gcd, "Int",a, "Int",b)
}

MCode(ByRef code, hex) { ; allocate memory and write Machine Code there
	VarSetCapacity(code, StrLen(hex) // 2)
	Loop % StrLen(hex) // 2
		NumPut("0x" . SubStr(hex, 2 * A_Index - 1, 2), code, A_Index - 1, "Char")
}
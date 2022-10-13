MCode_Bin2Hex(addr, len, ByRef hex) { 							;-- By Lexikos, http://goo.gl/LjP9Zq
	Static fun
	If (fun = "") {
		If Not A_IsUnicode
			h =
			( LTrim Join
				8B54240C85D2568B7424087E3A53578B7C24148A07478AC8C0E90480F9090F97C3F6
				DB80E30702D980C330240F881E463C090F97C1F6D980E10702C880C130880E464A75
				CE5F5BC606005EC3
			)
		Else
			h =
			( LTrim Join
				8B44240C8B4C240485C07E53568B74240C578BF88A168AC2C0E804463C090FB6C076
				066683C037EB046683C03066890180E20F83C10280FA09760C0FB6D26683C2376689
				11EB0A0FB6C26683C03066890183C1024F75BD33D25F6689115EC333C0668901C3
			)
		VarSetCapacity(fun, n := StrLen(h)//2)
		Loop % n
			NumPut("0x" . SubStr(h, 2 * A_Index - 1, 2), fun, A_Index - 1, "Char")
	}
	hex := ""
	VarSetCapacity(hex, A_IsUnicode ? 4 * len + 2 : 2 * len + 1)
	DllCall(&fun, "uint", &hex, "uint", addr, "uint", len, "cdecl")
	VarSetCapacity(hex, -1) ;update StrLen
}
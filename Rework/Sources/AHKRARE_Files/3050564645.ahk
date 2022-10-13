getSysLocale() { 																									;-- gets the system language

	; fork of http://stackoverflow.com/a/7759505/883015
	VarSetCapacity(buf_a,9,0), VarSetCapacity(buf_b,9,0)
	f:="GetLocaleInfo" (A_IsUnicode?"W":"A")
	DllCall(f,"Int",LOCALE_SYSTEM_DEFAULT:=0x800
			,"Int",LOCALE_SISO639LANGNAME:=89
			,"Str",buf_a,"Int",9)
	DllCall(f,"Int",LOCALE_SYSTEM_DEFAULT
			,"Int",LOCALE_SISO3166CTRYNAME:=90
			,"Str",buf_b,"Int",9)
	return buf_a "-" buf_b
}
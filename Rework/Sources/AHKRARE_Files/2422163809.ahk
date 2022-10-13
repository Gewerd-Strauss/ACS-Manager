HIconFromBuffer(ByRef Buffer, width, height) {                                                           	;-- Function provides a HICON handle e.g. from a resource previously loaded into memory (LoadScriptResource)

	;Ptr := Ptr ? "Ptr" : "Uint"	; For AutoHotkey Basic Users
	hIcon := DllCall( "CreateIconFromResourceEx"
        , UInt, &Buffer+22
        , UInt, NumGet(Buffer,14)
        , Int,1
        , UInt, 0x30000
        , Int, width
        , Int, height
        , UInt, 0
        , Ptr)
	return hIcon
}
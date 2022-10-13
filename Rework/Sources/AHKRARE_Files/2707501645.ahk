StdErr_Write(LineNumber, text, spec = "") {                                                            	;-- write directly to stderr for custom error messages


	text := A_ScriptFullPath " (" LineNumber ") : ==>  " . text
	text .= spec?"`n     Specifically: " spec "`n":
    if A_IsUnicode
        return StdErr_Write_("astr", text, StrLen(text))
    return StdErr_Write_("uint", &text, StrLen(text))

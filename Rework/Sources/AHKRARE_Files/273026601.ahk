StdErr_Write(LineNumber, text, spec = "") {
	text := A_ScriptFullPath " (" LineNumber ") : ==>  " . text
	text .= spec?"`n     Specifically: " spec "`n":
    if A_IsUnicode
        return StdErr_Write_("astr", text, StrLen(text))
    return StdErr_Write_("uint", &text, StrLen(text))
}
StdErr_Write_(type, data, size) {
    static STD_ERROR_HANDLE := -12
    if (hstderr := DllCall("GetStdHandle", "uint", STD_ERROR_HANDLE)) = -1
        return false
    return DllCall("WriteFile", "uint", hstderr, type, data, "uint", size, "uint", 0, "uint", 0)
}
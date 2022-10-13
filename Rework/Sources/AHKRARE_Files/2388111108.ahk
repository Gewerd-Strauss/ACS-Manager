TaskDialogToUnicode(String, ByRef Var) {                            						     		;-- part of TaskDialog ?

	VarSetCapacity(Var, StrPut(String, "UTF-16") * 2, 0)
	StrPut(String, &Var, "UTF-16")
	return &Var
}
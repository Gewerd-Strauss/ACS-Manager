StrPutVar(string, ByRef var, encoding) {    										;-- Convert the data to some Enc, like UTF-8, UTF-16, CP1200 and so on
    VarSetCapacity( var, StrPut(string, encoding)
        * ((encoding="cp1252"||encoding="utf-16") ? 2 : 1) )
    return StrPut(string, &var, encoding)
}
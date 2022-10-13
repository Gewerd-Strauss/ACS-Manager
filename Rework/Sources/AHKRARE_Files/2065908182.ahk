ReplaceForbiddenChars(S_IN, ReplaceByStr = "") {							;-- hopefully working, not tested function, it uses RegExReplace

   Replace_RegEx := "im)[\/:*?""<>|]*"

   S_OUT := RegExReplace(S_IN, Replace_RegEx, "")
   if (S_OUT = 0)
      return, S_IN
   if (ErrorLevel = 0) and (S_OUT <> "")
      return, S_OUT
}
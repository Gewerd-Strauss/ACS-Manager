GetFontProperties(HFONT) {                                                                                       	;-- to get the current font's width and height
   ; LOGFONT -> http://msdn.microsoft.com/en-us/library/dd145037%28v=vs.85%29.aspx
   VarSetCapacity(LF, (4 * 5) + 8 + 64) ; LOGFONT Unicode
   Size := DllCall("Gdi32.dll\GetObject", "Ptr", HFONT, "Int", Size, "Ptr", 0)
   DllCall("Gdi32.dll\GetObject", "Ptr", HFONT, "Int", Size, "Ptr", &LF)
   Font := {}
   Font.Height := Round(Abs(NumGet(LF, 0, "Int")) * 72 / A_ScreenDPI, 1)
   Font.Width := Round(Abs(NumGet(LF, 4, "Int")) * 72 / A_ScreenDPI, 1)
   Font.Escapement := NumGet(LF, 8, "Int")
   Font.Orientation := NumGet(LF, 12, "Int")
   Font.Weight := NumGet(LF, 16, "Int")
   Font.Italic := NumGet(LF, 20, "UChar")
   Font.Underline := NumGet(LF, 21, "UChar")
   Font.StrikeOut := NumGet(LF, 22, "UChar")
   Font.CharSet := NumGet(LF, 23, "UChar")
   Font.OutPrecision := NumGet(LF, 24, "UChar")
   Font.ClipPrecision := NumGet(LF, 25, "UChar")
   Font.Quality := NumGet(LF, 26, "UChar")
   Font.PitchAndFamily := NumGet(LF, 27, "UChar")
   Font.FaceName := StrGet(&LF + 28, 32)
   Return Font
}
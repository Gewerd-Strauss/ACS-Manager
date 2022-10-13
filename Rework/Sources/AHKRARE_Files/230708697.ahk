FloatToHex(value) {																			;-- Float to Hexadecimal conversion

   format := A_FormatInteger
   SetFormat, Integer, H
   result := DllCall("MulDiv", Float, value, Int, 1, Int, 1, UInt)
   SetFormat, Integer, %format%
   Return, result
}
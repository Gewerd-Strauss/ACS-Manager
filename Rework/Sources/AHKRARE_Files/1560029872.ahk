NumStr(Value, Width, Dec, PadB4:="") {                                     	;-- Use to format a float or to pad leading characters (any character!) to a numeric string
  AFF := A_FormatFloat
  SetFormat, Float, 0.%Dec%
  Value += 0.00
  Loop
       If (StrLen(Value) < Width AND PadB4!="")
          Value := PadB4 Value
       else
          Break
  SetFormat, Float, %AFF%

Return Value
}
ARGBToRGB(ARGB) {																		;-- convert ARGB to RGB.
	/*                              	DESCRIPTION
			; Syntax: ARGBToRGB ([ARGB])
			; Return: RGB with the prefix 0x
			;Notes:
			If a RGB color is specified, it does not change it.
			If you specify an ARGB color, the transparency is removed.
			the prefix 0x does not matter, you can specify a whole number.
			;Example:
			; MsgBox% ARGBToRGB ("0x8000FF") "," ARGBToRGB ("8000FF")
			; . "`n "ARGBToRGB (" 0xFF8000FF ")", "ARGBToRGB (" FF8000FF ")

	*/

	return Hex(SubStr(SubStr(ARGB:=Hex(ARGB, 8), 1, 2)="0x"?SubStr(ARGB, 3):ARGB, -5), 6, true)
}
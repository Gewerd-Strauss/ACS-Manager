CircularText(Angle, Str, Width, Height, Font, Options){                                       	;-- given a string it will generate a bitmap of the characters drawn with a given angle between each char

	;-- Given a string it will generate a bitmap of the characters drawn with a given angle between each char, if the angle is 0 it will try to make the string fill the entire circle.
	;--https://autohotkey.com/boards/viewtopic.php?t=32179
	;--by Capn Odin 23 Mai 2017

	pBitmap := Gdip_CreateBitmap(Width, Height)

	G := Gdip_GraphicsFromImage(pBitmap)

	Gdip_SetSmoothingMode(G, 4)

	if (!Angle) {
		Angle := 360 / StrLen(Str)
	}

	for i, chr in StrSplit(Str) {
		RotateAroundCenter(G, Angle, Width, Height)
		Gdip_TextToGraphics(G, chr, Options, Font, Width, Height)
	}

	Gdip_DeleteGraphics(G)

	Return pBitmap
}
CreateDIB( PixelData, W, H, ResizeW := 0, ResizeH := 0, Gradient := 1  ) {          	;-- a wonderfull function by SKAN to draw tiled backgrounds (like chess pattern) to a gui, it can also draw gradients
		Static LR_Flag1 := 0x2008 ; LR_CREATEDIBSECTION := 0x2000 | LR_COPYDELETEORG := 8
			,  LR_Flag2 := 0x200C ; LR_CREATEDIBSECTION := 0x2000 | LR_COPYDELETEORG := 8 | LR_COPYRETURNORG := 4
			,  LR_Flag3 := 0x0008 ; LR_COPYDELETEORG := 8
		WB := Ceil( ( W * 3 ) / 2 ) * 2,  VarSetCapacity( BMBITS, WB * H + 1, 0 ),  P := &BMBITS
		Loop, Parse, PixelData, |
		P := Numput( 
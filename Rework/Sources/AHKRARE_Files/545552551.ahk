Gdip_CropBitmap(pBitmap, left, right, up, down, Dispose=1) {                          	;-- returns cropped bitmap. Specify how many pixels you want to crop (omit) from each side of bitmap rectangle
		Gdip_GetImageDimensions(pBitmap, origW, origH)
		NewWidth := origW-left-right, NewHeight := origH-up-down
		pBitmap2 := Gdip_CreateBitmap(NewWidth, NewHeight)
		G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 4), Gdip_SetInterpolationMode(G2, 7)
		Gdip_DrawImage(G2, pBitmap, 0, 0, NewWidth, NewHeight, left, up, NewWidth, NewHeight)
		Gdip_DeleteGraphics(G2)
		if Dispose
				Gdip_DisposeImage(pBitmap)

return pBitmap2
}
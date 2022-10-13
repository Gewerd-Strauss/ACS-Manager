Screenshot(outfile, screen) {                                                                                 	;-- screenshot function 1

    pToken := Gdip_Startup()
    raster := 0x40000000 + 0x00CC0020 ; get layered windows

    pBitmap := Gdip_BitmapFromScreen(screen, raster)

    Gdip_SetBitmapToClipboard(pBitmap)
    Gdip_SaveBitmapToFile(pBitmap, outfile)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)

    PlaceTooltip("Screenshot copied and saved.")
}
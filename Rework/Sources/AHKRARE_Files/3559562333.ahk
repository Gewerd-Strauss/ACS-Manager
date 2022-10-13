Redraw(hwnd=0) {																									;-- redraws the overlay window(s) using the position, text and scrolling settings

    ;This function redraws the overlay window(s) using the position, text and scrolling settings
    global MainOverlay, PreviewOverlay, PreviewWindow, MainWindow
	outputdebug redraw
	;Called without parameters, recursive calls for both overlays
	if (hwnd=0)
	{
		if (MainOverlay && PreviewOverlay)
		{
			Redraw(MainWindow)
			Redraw(PreviewWindow)
			return
		}
		Else
		{
			msgbox Redraw() called with invalid window handle
			Exit
		}
	}
	;Get Position of overlay area and text position
	GetOverlayArea(x,y,w,h,hwnd)
	GetAbsolutePosition(CenterX,CenterY,hwnd)
	GetDrawingSettings(text,font,FontColor,style,BackColor,hwnd)

	; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
	hbm := CreateDIBSection(w, h)

	; Get a device context compatible with the screen
	hdc := CreateCompatibleDC()

	; Select the bitmap into the device context
	obm := SelectObject(hdc, hbm)

	; Get a pointer to the graphics of the bitmap, for use with drawing functions
	G := Gdip_GraphicsFromHDC(hdc)

	; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)
	Gdip_SetSmoothingMode(G, 4)
	Gdip_SetTextRenderingHint(G, 1)
	; Create a partially transparent, black brush (ARGB = Transparency, red, green, blue) to draw a rounded rectangle with
	pBrush := Gdip_BrushCreateSolid(backcolor)
	hFont := Font("", style "," font )
	size := Font_DrawText(text, hdc, hFont, "CALCRECT")		;measure the text, use already created font
	StringSplit, size, size, .
	FontWidth := size1,	FontHeight := size2
	DrawX:=CenterX-Round(FontWidth/2)
	DrawY:=CenterY-Round(FontHeight/2)

	corners:=min(Round(min(FontWidth,FontHeight)/5),20)
	Gdip_FillRoundedRectangle(G, pBrush, DrawX, DrawY, FontWidth, FontHeight, corners)
	; Delete the brush as it is no longer needed and wastes memory
	Gdip_DeleteBrush(pBrush)

	Options = x%DrawX% y%DrawY% cff%FontColor% %style% r4
	Gdip_TextToGraphics(G, text, Options, Font)
	; Update the specified window we have created (hwnd1) with a handle to our bitmap (hdc), specifying the x,y,w,h we want it positioned on our screen
	; With some simple maths we can place the gui in the centre of our primary monitor horizontally and vertically at the specified heigth and width
	if (hwnd=PreviewWindow)
		UpdateLayeredWindow(PreviewOverlay, hdc, x, y, w, h)
	else if (hwnd=MainWindow)
		UpdateLayeredWindow(MainOverlay, hdc, x, y, w, h)

	; Select the object back into the hdc
	SelectObject(hdc, obm)

	; Now the bitmap may be deleted
	DeleteObject(hbm)

	; Also the device context related to the bitmap may be deleted
	DeleteDC(hdc)

	; The graphics may now be deleted
	Gdip_DeleteGraphics(G)
}
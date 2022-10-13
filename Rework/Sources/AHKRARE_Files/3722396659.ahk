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
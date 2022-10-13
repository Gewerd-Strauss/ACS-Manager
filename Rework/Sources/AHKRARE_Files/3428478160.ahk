DrawRectangle(startNewRectangle := false) {                                                     	;-- this is for screenshots

	static lastX, lastY
	static xorigin, yorigin

	if (startNewRectangle) {
	  MouseGetPos, xorigin, yorigin
	}

	CoordMode, Mouse, Screen
	MouseGetPos, currentX, currentY

	; Has the mouse moved?
	if (lastX lastY) = (currentX currentY)
	return

	lastX := currentX
	lastY := currentY

	x := Min(currentX, xorigin)
	w := Abs(currentX - xorigin)
	y := Min(currentY, yorigin)
	h := Abs(currentY - yorigin)

	Gui, ScreenshotSelection:Show, % "NA X" x " Y" y " W" w " H" h
	Gui, ScreenshotSelection:+LastFound
}
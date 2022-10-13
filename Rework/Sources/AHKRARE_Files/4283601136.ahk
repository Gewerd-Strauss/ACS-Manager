TakeScreenshot(dir) {                                                                                            	;-- screenshot function 2

    CoordMode, Mouse, Screen
    MouseGetPos, begin_x, begin_y
    DrawRectangle(true)
    SetTimer, rectangle, 10
    KeyWait, RButton

    SetTimer, rectangle, Off
    Gui, ScreenshotSelection:Cancel
    MouseGetPos, end_x, end_y

    Capture_x := Min(end_x, begin_x)
    Capture_y := Min(end_y, begin_y)
    Capture_width := Abs
DrawFrameAroundControl(ControlID, WindowUniqueID, frame_t) {                  	;-- paints a rectangle around a specified control

    global h_brushC, h_brushW, ChkDrawRectCtrl, ChkDrawRectWin

    ;get coordinates of Window and control again
    ;(could have been past into the function but it seemed too much parameters)
    WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, ahk_id %WindowUniqueID%
    ControlGetPos, ControlX, ControlY, ControlWidth, ControlHeight, %ControlID%, ahk_id %WindowUniqueID%

    ;find upper left corner relative to screen
    StartX := WindowX + ControlX
    StartY := WindowY + ControlY

    ;show ID in
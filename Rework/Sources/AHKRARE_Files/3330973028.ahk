DrawFrameAroundControl(ControlID, WindowUniqueID, frame_t) {                  	;-- paints a rectangle around a specified control

    global h_brushC, h_brushW, ChkDrawRectCtrl, ChkDrawRectWin

    ;get coordinates of Window and control again
    ;(could have been past into the function but it seemed too much parameters)
    WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, ahk_id %WindowUniqueID%
    ControlGetPos, ControlX, ControlY, ControlWidth, ControlHeight, %ControlID%, ahk_id %WindowUniqueID%

    ;find upper left corner relative to screen
    StartX := WindowX + ControlX
    StartY := WindowY + ControlY

    ;show ID in upper left corner
    CoordMode, ToolTip, Screen

    ;show frame gui above AOT apps
    Gui, 2: +AlwaysOnTop

    If ChkDrawRectWin {
        ;if windows upper left corner is outside the screen
        ; it is assumed that the window is maximized and the frame is made smaller
        If ( WindowX < 0 AND WindowY < 0 ){
            WindowX += 4
            WindowY += 4
            WindowWidth -= 8
            WindowHeight -= 8
          }

        ;remove old rectangle from screen and save/buffer screen below new rectangle
        BufferAndRestoreRegion( WindowX, WindowY, WindowWidth, WindowHeight )

        ;draw rectangle frame around window
        DrawFrame( WindowX, WindowY, WindowWidth, WindowHeight, frame_t, h_brushW )

        ;show tooltip above window frame when enough space
        If ( WindowY > 22)
            WindowY -= 22

        ;Show tooltip with windows unique ID
        ToolTip, %WindowUniqueID%, WindowX, WindowY, 3
      }
    Else
        ;remove old rectangle from screen and save/buffer screen below new rectangle
        BufferAndRestoreRegion( StartX, StartY, ControlWidth, ControlHeight )

    If ChkDrawRectCtrl {
        ;draw rectangle frame around control
        DrawFrame( StartX, StartY, ControlWidth, ControlHeight, frame_t, h_brushC )

        ;show tooltip above control frame when enough space, or below
        If ( StartY > 22)
            StartY -= 22
        Else
            StartY += ControlHeight

        ;show control tooltip left of window tooltip if position identical (e.g. Windows Start Button on Taskbar)
        If (StartY = WindowY
            AND StartX < WindowX + 50)
            StartX += 50

        ;Show tooltip with controls unique ID
        ToolTip, %ControlID%, StartX, StartY, 2
      }
    ;set back ToolTip position to default
    CoordMode, ToolTip, Relative
}
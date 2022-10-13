FocuslessScrollHorizontal(MinLinesPerNotch, MaxLinesPerNotch, 							;--
AccelerationThreshold, AccelerationType, StutterThreshold) {

	;https://autohotkey.com/board/topic/99405-hoverscroll-verticalhorizontal-scroll-without-focus-scrollwheel-acceleration/page-5

    SetBatchLines, -1 ;Run as fast as possible
    CoordMode, Mouse, Screen ;All coords relative to screen

    ;Stutter filter: Prevent stutter caused by cheap mice by ignoring successive WheelUp/WheelDown events that occur to close together.
    if (A_TimeSincePriorHotkey < StutterThreshold) ;Quickest succession time in ms
        if (A_PriorHotkey = "WheelUp" Or A_PriorHotkey ="WheelDown")
            Return

    MouseGetPos, m_x, m_y,, ControlClass2, 2
    ControlClass1 := DllCall( "WindowFromPoint", "int64", (m_y << 32) | (m_x & 0xFFFFFFFF), "Ptr") ;32-bit and 64-bit support

    ctrlMsg := 0x114    ; WM_HSCROLL
    wParam := 0         ; Left

    ;Detect WheelDown event
    if (A_ThisHotkey = "WheelDown" Or A_ThisHotkey = "^WheelDown" Or A_ThisHotkey = "+WheelDown" Or A_ThisHotkey = "*WheelDown")
        wParam := 1 ; Right

    ;Adjust lines per notch according to scrolling speed
    Lines := LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)

    Loop %Lines%
    {
        SendMessage, ctrlMsg, wParam, 0,, ahk_id %ControlClass1%
        if (ControlClass1 != ControlClass2)
            SendMessage, ctrlMsg, wParam, 0,, ahk_id %ControlClass2%
    }
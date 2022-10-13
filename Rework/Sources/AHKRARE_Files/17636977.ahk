MoveTogether(wParam, lParam, _, hWnd) { 																;-- move 2 windows together - using DllCall to DeferWindowPos

	/*                              	DESCRIPTION

				Link: https://autohotkey.com/boards/viewtopic.php?t=43192
				AutoExec in Script or inside function
				;---------------------------------------------
			    CoordMode, Mouse, Screen    ; for MouseGetPos
			    SetBatchLines, -1           ; for onMessage
			    SetWinDelay, -1             ; for WinActivate
			    ;---------------------------------------------

				 call MoveTogether(Handles) with an array of handles
				 to set up a bundle of AHK Gui's that move together

				 https://autohotkey.com/boards/viewtopic.php?p=199402#p199402
				 version 2018.02.08
	*/
    static init := OnMessage(0xA1, "MoveTogether") ; WM_NCLBUTTONDOWN
    static Handles

	If IsObject(wParam)             ; detect a set up call
		Return, Handles := wParam   ; store the array of handles

    If (wParam != 2) ; HTCAPTION
        Return

    ; changing AHK settings here will have no side effects
    CoordMode, Mouse, Screen    ; for MouseGetPos
    SetBatchLines, -1           ; for onMessage
    SetWinDelay, -1             ; for WinActivate, WinMove

    M_old_X := lParam & 0xFFFF, M_old_Y := lParam >> 16 & 0xFFFF
    WinActivate, ahk_id %hWnd%

    Win := {}
    For each, Handle in Handles {
        WinGetPos, X, Y, W, H, ahk_id %Handle%
        Win[Handle] := {X: X, Y: Y, W: W, H: H}
    }

    While GetKeyState("LButton", "P") {
        MouseGetPos, M_new_X, M_new_Y
        dX := M_new_X - M_old_X, M_old_X := M_new_X
      , dY := M_new_Y - M_old_Y, M_old_Y := M_new_Y

        If GetKeyState("Shift", "P")
            WinMove, ahk_id %hWnd%,, Win[hWnd].X += dX, Win[hWnd].Y += dY

        Else { ; DeferWindowPos cycle
            hDWP := DllCall("BeginDeferWindowPos", "Int", Handles.Length(), "Ptr")
            For each, Handle in Handles
                hDWP := DllCall("DeferWindowPos", "Ptr", hDWP
                    , "Ptr", Handle, "Ptr", 0
                    , "Int", Win[Handle].X += dX
                    , "Int", Win[Handle].Y += dY
                    , "Int", Win[Handle].W
                    , "Int", Win[Handle].H
                    , "UInt", 0x214, "Ptr")
            DllCall("EndDeferWindowPos", "Ptr", hDWP)
        }
    }
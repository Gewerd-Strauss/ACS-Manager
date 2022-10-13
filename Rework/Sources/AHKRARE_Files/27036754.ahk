MoveMouse_Spiral(cx, cy, r, s, a) { 															        			;-- move mouse in a spiral

	/*    	DESCRIPTION

			Link:	        	https://autohotkey.com/boards/viewtopic.php?t=58006
			Author:    	wolf_II

	*/
;-----------------------------------------------------------------------------
;----------------------------------------------------------------------------
    ; cx, cy = center coordinates    ; s = number of steps

    ; r = radius---
    ; a = number of spiral arms
    ;---------------------------------------------------------------------------
    $Pi := 4 * ATan(1)
    MouseClick, Left, cx, cy,, 0, D

    Loop, % s * a

			MouseMove

            , cx + r * Cos(A_Index * 2 * $Pi / s) * A_Index / s
            , cy + r * Sin(A_Index * 2 * $Pi / s) * A_Index / s
            Sleep 1 ; ms
            ,, 0
            Sleep 1 ; ms
}
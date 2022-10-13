WM_WINDOWPOSCHANGING(wParam, lParam) {	                        	;-- two different examples of handling a WM_WINDOWPOSCHANGING
    if (A_Gui = 1 && !(NumGet(lParam+24) & 0x2)) ; SWP_NOMOVE=0x2
    {
        x := NumGet(lParam+8),  y := NumGet(lParam+12)
        x += 10,  y += 30
        Gui, 2:Show, X%x% Y%y% NA
    }
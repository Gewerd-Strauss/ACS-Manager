SetAlpha(hwnd, alpha) {                                                                                       	;-- set alpha to a layered window

    DllCall("UpdateLayeredWindow","uint",hwnd,"uint",0,"uint",0
        ,"uint",0,"uint",0,"uint",0,"uint",0,"uint*",alpha<<16|1<<24,"uint",2)
}
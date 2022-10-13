Popup(title, action, close=true, image="", w=197, h=46) {                            	    	;-- Splashtext Gui

    SysGet, Screen, MonitorWorkArea
    ScreenRight-=w+3
    ScreenBottom-=h+4
    SplashImage,%image%,CWe0dfe3 b1 x%ScreenRight% y%ScreenBottom% w%w% h%h% C00 FM8 FS8, %action%,%title%,Popup
    WinSet, Transparent, 216, Popup
    if close
        SetTimer, ClosePopup, -2000
    return

	ClosePopup:
    WinGet,WinID,ID,Popup
    MouseGetPos,,,MouseWinID
    ifEqual,WinID,%MouseWinID%
    {
        SetTimer, ClosePopup, -2000
    }else{
        SplashImage, Off
    }
    return
}
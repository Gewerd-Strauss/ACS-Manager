movable() {																													;-- makes Gui movable
Gui 2:+LastFound
Gui1 := WinExist()
 DllCall( "GetSystemMenu", UInt,Gui1, Int,True )
Return DllCall( "DrawMenuBar", UInt,Gui1 ) ? 1 : 0
}
CreateCircleProgress(diameter:=50,thickness:=5,color:=0x99009933,               	;-- very nice to see functions for a circle progress
xPos:="center",yPos:="center",guiId:=1) {

	; from Learning one
	; https://autohotkey.com/boards/viewtopic.php?t=6947
    width := height := diameter+thickness*2
    xPos := (xPos=="center" ? A_ScreenWidth/2-diameter/2-thickness : xPos)
    yPos := (yPos=="center" ? A_ScreenHeight/2-diameter/2-thickness : yPos)
    Gui, %guiId%: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
    Gui, %guiId%: Show, NA

    hwnd := WinExist()
    hbm := CreateDIBSection(width, height)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    G := Gdip_GraphicsFromHDC(hdc)
    Gdip_SetSmoothingMode(G, 4)

    pen:=Gdip_CreatePen(color, thickness)
    Gdip_SetCompositingMode(G, 1)
    Return {hwnd:hwnd, hdc:hdc, obm:obm, hbm:hbm, pen:pen, G:G, diameter: diameter, thickness:thickness, xPos:xPos, yPos:yPos, width:width, height:height}
}
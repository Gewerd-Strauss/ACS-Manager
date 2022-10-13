CenterWindow(aWidth,aHeight) {																				;-- Given a the window's width and height, calculates where to position its upper-left corner so that it is centered EVEN IF the task bar is on the left side or top side of the window
	static rect:=Struct("left,top,right,bottom"),SPI_GETWORKAREA:=48,pt:=Struct("x,y")
	DllCall("SystemParametersInfo","Int",SPI_GETWORKAREA,"Int", 0,"PTR", rect[],"Int", 0)  ; Get desktop rect excluding task bar.
	; Note that rect.left will NOT be zero if the taskbar is on docked on the left.
	; Similarly, rect.top will NOT be zero if the taskbar is on docked at the top of the screen.
	pt.x := rect.left + (((rect.right - rect.left) - aWidth) / 2)
	pt.y := rect.top + (((rect.bottom - rect.top) - aHeight) / 2)

return pt
}
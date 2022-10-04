Function1()
{
	


	
	1	yc:=A_ScreenHeight-200
			xc:=A_ScreenWidth-300
	Gui, cQ: show,autosize  x%xc% y%yc%, CQ%A_ThisLabel%
	WinGetPos,,,Width,Height,CQ%A_ThisLabel%
	NewXGui:=A_ScreenWidth-Width
	NewYGui:=A_ScreenHeight-Height
	Gui, cQ: show,autosize  x%NewXGui% y%NewYGui%, CQ%A_ThisLabel%
	Gui, cQ: show,autosize, CQ%A_ThisLabel%
	winactivate, CQ
	return answer
}
;--uID:Hash_1438520671
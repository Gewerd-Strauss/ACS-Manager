LV_SetItemPos(hWnd, Item, x := "", y := "") {																	;-- set the position of an item
/*                              	DESCRIPTION

set the position of an item
Syntax: LV_SetItemPos ([ID], [item], [x], [y])

*/

	if (x="") || (y="")
	LV_GetItemPos(hWnd, Item, _x, _y)
	return SendMessage(hWnd, 0x100F,, Item-1,, LOWORD(x=""?_x:x)+HIWORD(y=""?_y:y, false))
	} LV_SetItemPosEx(hWnd, Item, x := "", y := "", ProcessId := "") {
	if (x="") || (y="")
	LV_GetItemPosEx(hWnd, Item, _x, _y, ProcessId)

return SendMessage(hWnd, 0x100F,, Item-1,, LOWORD(x=""?_x:x)+HIWORD(y=""?_y:y, false))
}
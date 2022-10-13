LV_GetItemPos(hWnd, Item, ByRef x := "", ByRef y := "") {												;-- obtains the position of an item
/*                              	DESCRIPTION

; get position of an item
; Syntax: LV_GetItemPos ([ID], [item], [x (output)], [y (output)])
; Note: returns an Array with the position xy.

*/

VarSetCapacity(POINT, A_PtrSize*2, 0), SendMessage(hWnd, 0x1010,, Item-1,, &POINT)
return [x:=NumGet(POINT, 0, "In
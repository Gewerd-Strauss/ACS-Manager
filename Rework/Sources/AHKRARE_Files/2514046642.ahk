LV_GetIconSpacing(hWnd, ByRef cx := "", ByRef cy := "") {												;-- Get the space between icons in the icon view
/*                              	DESCRIPTION

Get the space between icons in the icon view.
; Syntax: LV_GetIconSpacing ([ID], [x-axis, distance in pixels (output)], [y-axis, distance in pixels (output)])

*/

IcSp := SendMessage(hWnd, 0x1033)
return [cx:=(IcSp & 0xFFFF), cy:=(IcSp >> 16)]
}
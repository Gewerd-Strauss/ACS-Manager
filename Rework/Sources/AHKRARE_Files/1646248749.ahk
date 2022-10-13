LV_SetIconSpacing(hWnd, cx, cy) {																					;-- Sets the space between icons in the icon view

	/*                              	DESCRIPTION

	; Sets the space between icons in the icon view.
	; Syntax: LV_SetIconSpacing ([ID], [x-axis, distance in pixels], [y-axis, distance in pixels])

	*/

	cx := ((cx<4)&&(cx!=-1))?4:cx, cy := ((cy<4)&&(cy!=-1))?4:cy

return SendMessage(hWnd, 0x1035,,,, LOWORD(cx)+HIWORD(cy, false))
}
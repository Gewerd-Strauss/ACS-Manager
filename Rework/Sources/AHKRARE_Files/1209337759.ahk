LV_MouseGetCellPos(ByRef LV_CurrRow, ByRef LV_CurrCol, LV_LView) {						;-- returns the number (row, col) of a cell in a listview at present mouseposition

LVIR_LABEL = 0x0002					;LVM_GETSUBITEMRECT constant - get label info
LVM_GETITEMCOUNT = 4100			;gets total number of rows
LVM_SCROLL = 4116						;scrolls the listview
LVM_GETTOPINDEX = 4135			;gets the first displayed row
LVM_GETCOUNTPERPAGE = 4136	;gets number of displayed rows
LVM_GETSUBITEMRECT = 4152		;gets cell width,height,x,y
ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %LV_LView%	;get info on listview

SendMessage, LVM_GETITEMCOUNT, 0, 0, , ahk_id %LV_LView%
LV_TotalNumOfRows := ErrorLevel	;get total number of rows
SendMessage, LVM_GETCOUNTPERPAGE, 0, 0, , ahk_id %LV_LView%
LV_NumOfRows := ErrorLevel	;get number of displayed rows
SendMessage, LVM_GETTOPINDEX, 0, 0, , ahk_id %LV_LView%
LV_topIndex := ErrorLevel	;get first displayed row

CoordMode, MOUSE, RELATIVE
MouseGetPos, LV_mx, LV_my
LV_mx -= LV_lx, LV_my -= LV_ly

VarSetCapacity(LV_XYstruct, 16, 0)	;create struct
Loop,% LV_NumOfRows + 1	;gets the current row and cell Y,H
{	LV_which := LV_topIndex + A_Index - 1	;loop through each displayed row
NumPut(LVIR_LABEL, LV_XYstruct, 0)	;get label info constant
NumPut(A_Index - 1, LV_XYstruct, 4)	;subitem index
SendMessage, LVM_GETSUBITEMRECT, %LV_which%, &LV_XYstruct, , ahk_id %LV_LView%	;get cell coords
LV_RowY := NumGet(LV_XYstruct,4)	;row upperleft y
LV_RowY2 := NumGet(LV_XYstruct,12)	;row bottomright y2
LV_currColHeight := LV_RowY2 - LV_RowY ;get cell height
if (LV_my <= LV_RowY + LV_currColHeight)	;if mouse Y pos less than row pos + height
{	LV_currRow  := LV_which + 1	;1-based current row
LV_currRow0 := LV_which		;0-based current row, if needed
;LV_currCol is not needed here, so I didn't do it! It will always be 0. See my ListviewInCellEditing function for details on finding LV_currCol if needed.
LV_currCol=0
Break
}
}
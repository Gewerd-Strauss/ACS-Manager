LV_MouseGetCellPos(ByRef LV_CurrRow, ByRef LV_CurrCol, LV_LView) {						;-- returns the number (row, col) of a cell in a listview at present mouseposition

LVIR_LABEL = 0x0002					;LVM_GETSUBITEMRECT constant - get label info
LVM_GETITEMCOUNT = 4100			;gets total number of rows
LVM_SCROLL = 4116						;scrolls the listview
LVM_GETTOPINDEX = 4135			;gets the first displayed row
LVM_GETCOUNTPERPAGE = 4136	;gets number of displayed rows
LVM_GETSUBITEMRECT = 4152		;gets cell width,height,x,y
ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %LV_LView%	;get info on listview

SendMessage, LVM_G
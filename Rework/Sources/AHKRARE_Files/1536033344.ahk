LV_GetSelectedText(FromColumns="",ColumnsDelimiter="`t",RowsDelimiter= "`n") { ;-- Returns text from selected rows in ListView (in a user friendly way IMO.)

; by Learning one,	https://autohotkey.com/board/topic/61750-lv-getselectedtext/
/*                                         	EXAMPLE
Gui 1: Add, ListView, x5 y5 w250 h300, First name|Last name|Occupation
LV_Add("","Jim","Tucker","Driver")
LV_Add("","Jill","Lochte","Artist")
LV_Add("","Jessica","Hickman","Student")
LV_Add("","Mary","Jones","Teacher")
LV_Add("","Tony","Jackman","Surfer")
Gui 1: Show, w260 h310
return

F1::MsgBox % LV_GetSelectedText() ; get text from selected rows
F2::MsgBox % LV_GetSelectedText("1|3") ; get text from 
#Include <JSON>

; Create some JSON
str = ["abc", 123, {"true": 1, "false": 0, "null": ""}, [true, false, null]]
obj := JSON.Load(str)

MsgBox, % obj[1] ; abc
MsgBox, % obj[2] ; 123

MsgBox, % obj[3].true ; 1
MsgBox, % obj[3].false ; 0
MsgBox, % obj[3].null ; *nothing*

MsgBox, % obj[4, 1] ; 1
MsgBox, % obj[4, 2] ; 0
MsgBox, % obj[4, 3] == JSON.Null ; 1

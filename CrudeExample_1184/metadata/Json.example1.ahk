#Include <JSON>

; Create an object with every supported data type
obj := ["abc", 123, {"true": true, "false": false, "null": ""}, [JSON.true, JSON.false, JSON.null]]

; Convert to JSON
MsgBox % JSON.Dump(obj) ; Expect: ["abc", 123, {"false": 0, "null": "", "true": 1}, [true, false, null]]

type(ByRef v) {																											;-- COM version: Returns the type of a value: "Integer", "String", "Float" or "Object"

	/*                              	DESCRIPTION

			By:					Lexikos
			Link: 				https://autohotkey.com/boards/viewtopic.php?f=6&t=2306
			Description:		COM version - reports the wrong type for integers outside 32-bit range.

	*/
	if IsObject(v)
		return "Object"
	a := ComObjArray(0xC, 1)
	a[0] := v
	DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue
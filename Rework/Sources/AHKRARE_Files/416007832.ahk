type(v) {																													;-- Object version: Returns the type of a value: "Integer", "String", "Float" or "Object"

	/*                              	DESCRIPTION

			By:					Lexikos
			Link: 				https://autohotkey.com/boards/viewtopic.php?f=6&t=2306
			Description: 	Object version - depends on current float format including a decimal point.
	*/
    if IsObject(v)
        return "Object"
    return v="" || [v].GetCapacity(1) ? "String" : InStr(v,".") ? "Float" : "Integer"
}
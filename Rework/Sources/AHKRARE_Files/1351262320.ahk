VarAdjustCapacity(ByRef Var) {                                                                                   	;-- adjusts the capacity of a variable to its content
	/*                              	DESCRIPTION

			Example:
			VarSetCapacity (OutputVar, 104857600, 0) attaches 100 MB to OutputVar
			OutputVar: = "123456789" assigns a string of characters to OutputVar
			MsgBox % "Contenido: " OutputVar "`nCapacidad: "
			VarSetCapacity(OutputVar) shows the content and current capacity of OutputVar, in bytes.
			VarAdjustCapacity (OutputVar) by applying the adjustment.
			MsgBox % "Contenido: " OutputVar "`nCapacidad: " VarSetCapacity(OutputVar) returns to show the current content and capacity of OutputVar, in bytes.

	*/

	return Capacity := VarSetCapacity(Var, -1)
	, OutputVar := Var, VarSetCapacity(Var, 0)
	, VarSetCapacity(Var, Capacity), Var := OutputVar
}
MoveMemory(ByRef Destination, Source, Bytes) {                                                      	;-- moves a block memory from one place to another
   	 /*                              	DESCRIPTION
 			Syntax: MoveMemory [[target], [source], [bytes])
	*/

	DllCall("msvcrt.dll\memmove_s", "Ptr", Destination, "UInt", Bytes, "Ptr", Source, "UInt", Bytes)
}
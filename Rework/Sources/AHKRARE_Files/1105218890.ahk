CopyMemory(ByRef Destination, Source, Bytes) {                                                       	;-- Copy a block of memory from one place to another
	/*                              	DESCRIPTION

			Syntax: CopyMemory[ [destination], [source], [bytes] )

	*/

	DllCall("msvcrt.dll\memcpy_s", "Ptr", Destination, "UInt", Bytes, "Ptr", Source, "UInt", Bytes)
}
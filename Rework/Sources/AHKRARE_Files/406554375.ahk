CoTaskMemAlloc(Bytes) {                                                                                            	;-- assign a working memory block
	/*                              	DESCRIPTION
                Syntax: CoTaskMemAlloc ([memory block size, in bytes])
			Return: hMem
	*/

	return DllCall("Ole32.dll\CoTaskMemAlloc", "UPtr", Bytes, "UPtr")
}
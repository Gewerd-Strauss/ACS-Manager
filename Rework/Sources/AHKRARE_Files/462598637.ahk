CoTaskMemRealloc(hMem, Bytes) {                                                                            	;-- change the size of a previously assigned block of working memory
	/*                              	DESCRIPTION

			.Syntax: CoTaskMemRealloc ([hMem], [new size for the memory block, in bytes])

	*/

	return DllCall("Ole32.dll\CoTaskMemRealloc",
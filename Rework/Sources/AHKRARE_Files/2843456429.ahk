RtlUlongByteSwap64(num) {                                                                                       	;-- routine reverses the ordering of the four bytes in a 32-bit unsigned integer value (AHK v1)
	/*                              	DESCRIPTION

                Link: https://autohotkey.com/boards/viewtopic.php?f=5&t=39002
                	- https://msdn.microsoft.com/en-us/library/windows/hardware/ff562886(v=vs.85).aspx (RtlUlongByteSwap routine)
                	- https://msdn.microsoft.com/en-us/library/e8cxb8tk.aspx (_swab function)
                A ULONG value to convert to a byte-swapped version
                For example, if the Source parameter value is 0x12345678, the routine returns 0x78563412.
                works on both 32 and 64 bit.
                v1 version

	*/

	static dest, src
	static i := varsetcapacity(dest,4) + varsetcapacity(
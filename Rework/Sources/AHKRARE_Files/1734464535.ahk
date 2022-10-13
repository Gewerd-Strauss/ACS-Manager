GetBinaryType(FileName) {																	                                                                    	;-- determines the bit architecture of an executable program
  IfNotExist, %FileName%, Return "File not found"
  Binary:=DllCall("GetBinaryType","Str", FileName, "UInt *", RetVal)
  IfEqual, Binary, 0, Return "Not Executable"
  BinaryTypes := "32-Bit|DOS|16-Bit|PIF|POSIX|OS2-16-Bit|64-Bit"
  StringSplit, BinaryType , BinaryTypes, |
  BinaryType:="BinaryType" . RetVal + 1
Return (%B
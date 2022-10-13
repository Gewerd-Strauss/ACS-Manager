FileCRC32(sFile="",cSz=4) {																	                                                                    	;-- computes and returns CRC32 hash for a File passed as parameter

	; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
	cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 10-Oct-2009
	hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
	IfLess,hFil,1, Return,hFil
	hMod := DllCall( "LoadLibrary", Str,"ntdll.dll" ), CRC32 := 0
	DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
	Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
		DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,Bytes, UInt,0 )
		, CRC32 := DllCall( "NTDLL\RtlComputeCrc32", UInt,CRC32, UInt,&Buffer, UInt,Bytes, UInt )
	DllCall( "CloseHandle", UInt,hFil )
	SetFormat, Integer, % SubStr( ( A_FI := A_FormatInteger ) "H", 0 )
	CRC32 := SubStr( CRC32 + 0x1000000000, -7 ), DllCall( "CharUpper", Str,CRC32 )
	SetFormat, Integer, %A_FI
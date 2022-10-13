CreateBMPGradient(File, RGB1, RGB2, Vertical=1) {                                            	;-- Horizontal/Vertical gradient


	; Left/Bottom -> Right/Top color, File is overwritten
	   If Vertical
		 H:="424d3e000000000000003600000028000000010000000200000001001800000000000800000000000000000000000000000000000000"
		   . BGR(RGB1) "00" BGR(RGB2) "00"
	   Else
		 H:="424d3e000000000000003600000028000000020000000100000001001800000000000800000000000000000000000000000000000000"
		   . BGR(RGB1) BGR(RGB2) "0000"

	   Handle:= DllCall("CreateFile",Str,file,Uint,0x40000000,Uint,0,UInt,0,UInt,4,Uint,0,UInt,0)

	   Loop 62 {
		 Hex := "0x" SubStr(H,2*A_Index-1,2)
		 DllCall("WriteFile", UInt,Handle, UCharP,Hex, UInt,1, UInt,0, UInt,0)
		}

	   DllCall("CloseHandle", "Uint", Handle)
}
ColorAdjL(Lum:=235, RGB:="") {                                                                         	;-- Adjust Luminance for a given RGB color
	 IfEqual, RGB,, Random, RGB, 1, 16777215
	 DllCall( "shlwapi\ColorRGBToHLS", UInt,RGB, UIntP,H, UIntP,L, UIntP,S )
	 CC := DllCall( "shlwapi\ColorHLSToRGB", UInt,H, UInt,Lum, UInt,S )
	 VarSetCapacity(RGB,6,0), DllCall( "msvcrt.dll\sprintf", Str,RGB, Str,"%06X", UInt,CC )
Return RGB
}
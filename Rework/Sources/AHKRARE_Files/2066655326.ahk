RGBRange(x, y=0, c=0, delim=",") {                                                                     	;-- returns an array for a color transition from x to y

	; RGBRange by [VxE]

	oif := A_FormatInteger
	SetFormat, Integer, H

	dr:=(y>>16&255)-(r:=x>>16&255)
	dg:=(y>>8&255)-(g:=x>>8&255)
	db:=(y&255)-(b:=x&255)
	d := sqrt(dr**2 + dg**2 + db**2)
	v := Floor(d/c)

	IfLessOrEqual, c, 0, SetEnv, c, % d/( v := c<-3 ? -1-Ceil(c) : 2 )
			s := c/d

	cr:=sqrt(d**2-dg**2-db**2)*s*((dr>0)*2-1)
	cg:=sqrt(d**2-dr**2-db**2)*s*((dg>0)*2-1)
	cb:=sqrt(d**2-dg**2-dr**2)*s*((db>0)*2-1)

	Loop %v% {
		u := SubStr("000000" SubStr( "" . ((Round(r+cr*A_Index)&255)<<16) | ((Round(g+cg*A_Index)&255)<<8) | (Round(b+cb*A_Index)&255), 3) ,-5)
		StringUpper, u,
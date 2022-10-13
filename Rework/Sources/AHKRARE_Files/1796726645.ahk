CatMull_ControlMove( px0, py0, px1, py1, px2, py2, 													;-- Moves the mouse through 4 points (without control point "gaps")
px3, py3, Segments=8, Rel=0, Speed=2 ) {
; Function by [evandevon]. Moves the mouse through 4 points (without control point "gaps"). Inspired by VXe's
;cubic bezier curve function (with some borrowed code).
   MouseGetPos, px0, py0
   If Rel
      px1 += px0, px2 += px0, px3 += px0, py1 += py0, py2 += py0, py3 += py0
   Loop % Segments - 1
   {
	;CatMull Rom Spline - Working
	  u := 1 - t := A_Index / Segments
	  cmx := Round(0.5*((2*px1) + (-px0+px2)*t + (2*px0 - 5*px1 +4*px2 - px3)*t**2 + (-px0 + 3*px1 - 3*px2 + px3)*t**3) )
	  cmy := Round(0.5*((2*py1) + (-py0+py2)*t + (2*py0 - 5*py1 +4*py2 - py3)*t**2 + (-py0 + 3*py1 - 3*py2 + py3)*t**3) )

	  MouseMove, cmx, cmy, Speed,

   }
   MouseMove, px3, py3, Speed
}
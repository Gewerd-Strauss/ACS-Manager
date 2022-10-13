DegreeToRadian(Degrees, Centesimal := false) {							;-- convert degree to radian (rad)
	/*                              	DESCRIPTION

			Syntax: RadianToDegree ([degrees], [centesimal?])
			 EXAMPLE
			MsgBox % DegreeToRadian(6875.493542) "`n" DegreeToRadian(7639.437268, true) ;120 | 120

	*/

	if (Centesimal)
		return Degrees*0.01570796326 ;pi/200 | 3.14159265359/200 = 0.01570796326
	return Degrees*0.01745329251 ;pi/180 | 3.14159265359/180 = 0.01745329251
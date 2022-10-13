RadianToDegree(Radians, Centesimal := false) {								;-- convert radian (rad) to degree
	/*                              	DESCRIPTION

			Syntax: RadianToDegree ([radians], [centesimal?])
			Example: MsgBox % RadianToDegree(120) "`n" RadianToDegree(120, true) ;6875.493542 | 7639.437268

	*/

	if (Centesimal)
		return Radians*63.6619772368 ;200/pi | 200/3.14159265359 = 63.6619772368
	
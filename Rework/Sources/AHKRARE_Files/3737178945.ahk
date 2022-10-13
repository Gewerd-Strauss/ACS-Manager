Color_RGBtoHSV( r, g, b, Byref h, Byref s, Byref v ) {						;-- converts beetween color two color spaces: RGB -> HSV
	;https://autohotkey.com/board/topic/71858-solved-help-coming-up-with-color-definitions/#p478116
	;from http://www.cs.rit.edu/~ncs/color/t_convert.html
	;// r,g,b values are from 0 to 1
	;// h = [0,360], s = [0,1], v = [0,1]
	;//		if s == 0, then h = -1 (undefined)
	min := MIN( r, g, b )
	max := MAX( r, g, b )
	v := max 				; v
	delta := max - min
	if ( max != 0 )
		s := delta / max  	; s
	else {
		;// r = g = b = 0		// s = 0, v is undefined
		s := 0
		h := -1
		return
	}
	if ( r = max )
		h := ( g - b ) / delta ;		// between yellow & magenta
	else if ( g == max )
		h := 2 + ( b - r ) / delta ;	// between cyan & yellow
	else
		h := 4 + ( r - g ) / delta ;	// between magenta & cyan
	h *= 60 ;				// degrees
	if ( h < 0 )
		h += 360 ;
	return
}
Color_HSVtoRGB( h, s, v, ByRef r, ByRef g, ByRef b ) {						;-- converts beetween color two color spaces: HSV -> RGB

	if ( s = 0 ) {
		;// achromatic (grey)
		r := v, g := v, b := v ;
		return
	}
	h /= 60 ;			// sector 0 to 5
	i := floor( h ) ;
	f := h - i ;			// factorial part of h
	p := v * ( 1 - s ) ;
	q := v * ( 1 - s * f ) ;
	t = v * ( 1 - s * ( 1 - f ) ) ;
	if (i = 0) {
		r := v
		g := t
		b := p
		Return
	}
	if (i = 1) {
		r := q
		g := v
		b := p
		Return
	}
	if (i = 2) {
		r := p
		g := v
		b := t
		Return
	}
	if (i = 3) {
		r := p
		g := q
		b := v
		Return
	}
	if (i = 4) {
		r := t
		g := p
		b := v
		Return
	}
	;default
	r := v
	g := p
	b := q
	Return
}
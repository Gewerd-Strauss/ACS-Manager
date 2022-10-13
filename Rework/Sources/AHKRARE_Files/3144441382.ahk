GetHueColorFromFraction(hue, brightness := 1) {                                              	;-- get hue color from fraction. example: h(0) is red, h(1/3) is green and h(2/3) is blue

	;https://autohotkey.com/boards/viewtopic.php?f=6&p=191294
	if (hue<0,hue:=abs(mod(hue, 1)))
		hue:=1-hue
	Loop 3
		col+=max(min(-8*abs(mod(hue+A_Index/3-0.5,1)-0.5)+2.5,1),0)*255*brightness<<16-(A_Index-1)*8
	return col
}
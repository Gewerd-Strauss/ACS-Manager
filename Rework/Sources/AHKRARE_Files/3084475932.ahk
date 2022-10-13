GetFreeGuiNum(start, prefix = "") {																				;-- gets a free gui number.
	/* Group: About
	o v0.81 by majkinetor.
	o Licenced under BSD <http://creativecommons.org/licenses/BSD/>
*/
	loop {
		Gui %prefix%%start%:+LastFoundExist
		IfWinNotExist
			return prefix start
		start++
		if (start = 100)
			return 0
	}
	return 0
}
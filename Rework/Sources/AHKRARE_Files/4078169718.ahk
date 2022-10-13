GetCenterCoords(guiW) {                                                                                        	;-- ?center a gui between 2 monitors?

	;https://github.com/number1nub/CreoWindows

	SysGet, numMons, MonitorCount
	SysGet, leftMon1, Monitor, 1
	leftMon := round(leftMon1Right)
	bottomMon := round(leftmon1bottom)
	If (numMons>1)
	{
		SysGet, totalMon, Monitor, 2
		rightMon := round(totalMonRight - leftMon)
		If (rightMon < 0)
		{
			leftMon  := round(leftMon+rightMon)
			rightMon := round(rightmon*-1)
		}
	}
	return { limit: leftMon, left: round((leftMon/2)-(guiW/2)), right: round((leftMon + (rightMon/2))-(guiW/2)) }
}
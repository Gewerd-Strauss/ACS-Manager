whichMonitor(x="",y="",byref monitorInfo="") { 												;-- return [current monitor, monitor count]
	CoordMode,mouse,screen
	if (x="" || y="")
		mousegetpos,x,y
	if !IsObject(monitorInfo)
		monitorInfo:=monitorInfo()

	for k,v in monitorInfo
		if (x>=v.l&&x<=v.r&&y>=v.t&&y<=v.b)
			return [k,monitorInfo.maxIndex()]
}
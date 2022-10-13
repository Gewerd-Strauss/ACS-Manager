CenterWindow(hWnd, Pos := "") {																				;-- center a window or set position optional by using Top, Left, Right, Bottom or a combination of it

	
	_gethwnd(hWnd), GetWindowPos(hWnd, x, y, w, h)
	, m := GetMonitorInfo(MonitorFromWindow(hWnd)), mx := m.wLeft, my := m.wTop, mw := m.wRight-mx, mh := m.wBottom-my
	, T := InStr(Pos, "Top"), B := InStr(Pos, "Bottom"), L := InStr(Pos, "Left"), R := InStr(Pos, "Right"), C := InStr(Pos, "Center")
	if WinMax(hWnd)
		w := (L||R)?Percent(mw/2, 10):mw, h := (T||B)?Percent(mh/2, 10):mh
	if (T) || (B) || (L) || (R)
		return MoveWindow(hWnd, (L?0:R?(mw-w):C?((mw/2)-(w/2)):x) +mx, (T?0:B?(mh-h):C?((mh/2)-(h/2)):y) +my, w, h)
	return MoveWindow(hWnd, ((mw/2) - (w/2)) +mx, ((mh/2) - (h/2)) +my, w, h)
}
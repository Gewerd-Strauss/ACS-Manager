FindWindow(title, class="", style="", exstyle="", processname="",                          	;-- Finds the first window matching specific criterias.
allowempty = false) {

	WinGet, id, list,,, Program Manager
	Loop, %id%
	{
		this_id := id%A_Index%
		WinGetClass, this_class, ahk_id %this_id%
		if (class && class!=this_class)
			Continue
		WinGetTitle, this_title, ahk_id %this_id%
		if (title && title!=this_title)
			Continue
		WinGet, this_style, style, ahk_id %this_id%
		if (style && style!=this_style)
			Continue
		WinGet, this_exstyle, exstyle, ahk_id %this_id%
		if (exstyle && exstyle!=this_exstyle)
			Continue
		WinGetPos ,,,w,h,ahk_id %this_id%
		if (!allowempty && (w=0 || h=0))
			Continue
		WinGet, this_processname, processname, ahk_id %this_id%
		if (processname && processname!=this_processname)
			Continue
		return this_id
	}
	return 0
}
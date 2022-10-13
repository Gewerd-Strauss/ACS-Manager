getTextById(byref html,id,trim=true) {                                                         	;--
	return trim ? trim(s:=getText(getHtmlById(html,id))) : s
}
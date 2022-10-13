getTextByTagName(byref html,tagName,trim=true) {		            				;--
	arr:=getHtmlByTagName(html,tagName)
	arr2:=[]
	for k,v in arr
		trim ? arr2.insert(trim(s:=getText(v))) : arr2.insert(s)
	return arr2
}
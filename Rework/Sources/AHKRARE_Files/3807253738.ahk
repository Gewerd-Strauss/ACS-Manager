getHtmlByTagName(byref html,tagName,outer=false) {		            			;--
	arr:=[]
	i:=0
	while i:=regexmatch(html,"is)<" tagName "(?:\s[^>]*)?>(.*?)<\s*\/\s*" tagName "\s*>",match,i+1)
		outer ? arr.insert(match) : arr.insert(match1)
	return arr
}
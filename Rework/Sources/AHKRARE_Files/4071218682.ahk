getText(byref html) {												            							;-- get text from html

	html:=RegExReplace(html,"[\n\r\t]+","")

	html:=regexreplace(html,"\s{2,}<"," <")
	html:=regexreplace(html,">\s{2,}","> ")
	html:=regexreplace(html,">\s+<","><")

	html:=RegExReplace(html,"is)<script[^>]*>.*?<\s*\/\s*script\s*>","")

	html:=regexreplace(html,"<[^<>]+>","")
	html:=regexreplace(html,"i)&nbsp;"," ")
	return html
}
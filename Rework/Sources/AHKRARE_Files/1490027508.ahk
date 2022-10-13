getHtmlById(byref html,id,outer=false) {		            										;--
	RegExMatch(html,"is)<([^>\s]+)[^>]*\sid=(?:(?:""" id """)|(?:'" id "')|(?:" id "))[^>]*>(.*?)<\s*\/\s*\1\s*>",match)
	return outer ? match : match2
}
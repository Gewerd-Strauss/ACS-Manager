GetHTMLbyTag(HTMLSource, Tag, Occurrence=1, Format=0) {	;-- uses COM

	;Format 0:Text 1:HTML 2:DOM
	ComError := ComObjError(false), `(oHTML := ComObjCreate("HtmlFile")).write(HTMLSource)
	if (Format = 2) {
		if (innerHTML := oHTML.getElementsByTagName(Tag)[Occurrence-1]["innerHTML"]) {
			`(oDOM := ComObjCreate("HtmlFile")).write(innerHTML)
			Return oDOM, ComObjError(ComError)
		} else
			Return "", ComObjError(ComError)
	}
	return (result := oHTML.getElementsByTagName(Tag)[Occurrence-1][(Format ? "innerHTML" : "innerTex
GetHTMLbyID(HTMLSource, ID, Format=0) {									;-- uses COM

	;Format 0:Text 1:HTML 2:DOM
	ComError := ComObjError(false), `(oHTML := ComObjCreate("HtmlFile")).write(HTMLSource)
	if (Format = 2) {
		if (innerHTML := oHTML.getElementById(ID)["innerHTML"]) {
			`(oDOM := ComObjCreate("HtmlFile")).write(innerHTML)
			Return oDOM, ComObjError(ComError)
		} else
			Return "", ComObjError(ComError)
	} else
	Return (result := oHTML.getElementById(ID)[(Format ? "innerHTML" : "innerText")]) ? result : "", ComObjError(ComError)
}
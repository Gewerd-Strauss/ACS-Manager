GoogleTranslate(phrase,LangIn,LangOut) {							            				;--

		Critical
		base := "https://translate.google.com.tw/?hl=en&tab=wT#"
		path := base . LangIn . "/" . LangOut . "/" . phrase
		IE := ComObjCreate("InternetExplorer.Application")
		;~ IE.Visible := true
		IE.Navigate(path)

		While IE.readyState!=4 || IE.document.readyState!="complete" || IE.busy
				Sleep 50

		Result := IE.document.all.result_box.innertext
		IE.Quit

return Result
}
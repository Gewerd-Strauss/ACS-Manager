URLDownloadToVar(url,ByRef variable="")
{
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open("GET",url)
	hObject.Send()
	return variable:=hObject.ResponseText
}
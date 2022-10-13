WBGet(WinTitle="ahk_class IEFrame", Svr#=1) { 														;-- AHK_Basic: based on Sean's GetWebBrowser function
	static msg, IID := "{332C4427-26CB-11D0-B483-00C04FD90119}" ; IID_IWebBrowserApp
	if Not msg
		msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
	SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
	if (ErrorLevel != "FAIL") {
		lResult:=ErrorLevel, GUID:=COM_GUID4String(IID_IHTMLDocument2,"{332C4425-26CB-11D0-B483-00C04FD90119}")
		DllCall("oleacc\ObjectFromLresult", "Uint",lResult, "Uint",GUID, "int",0, "UintP",pdoc)
		return COM_QueryService(pdoc,IID,IID), COM_Release(pdoc)
	}
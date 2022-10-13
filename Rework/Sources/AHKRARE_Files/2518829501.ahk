IE_getURL(t) {    																											 ;-- using shell.application
	If	psh	:=	COM_CreateObject("Shell.Application") {
		If	psw	:=	COM_Invoke(psh,	"Windows") {
			Loop, %	COM_Invoke(psw,	"Count")
				If	url	:=	(InStr(COM_Invoke(psw,"Item[" A_Index-1 "].LocationName"),t) && InStr(COM_Invoke(psw,"Item[" A_Index-1 "].FullName"), "iexplore.exe")) ? COM_Invoke(psw,"Item[" A_Index-1 "].LocationURL") :
					Break
			COM_Release(psw)
		}
		COM_Release(psh)
	}
	Return	url
}
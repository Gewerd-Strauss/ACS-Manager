WinForms_GetClassNN(WinID, fromElement, ElementName) {                              	;-- Check which ClassNN an element has

	; function by Ixiko 2018 last_change 28.01.02.2018
	/* Funktionsinfo: Deutsch
		;Achtung: da manchmal 2 verschiedene Elemente den gleichen Namen enthalten können hat die Funktion einen zusätzlichen Parameter: "fromElement"
		;die Funktion untersucht ob das hier angebene Element im ClassNN enthalten ist zb. Button in WindowsForms10.BUTTON.app.0.378734a2
		;die Groß- und Kleinschreibung ist nicht zu beachten
	*/

	/* function info: english
		;Caution: sometimes 2 and more different elements in a gui can contain the same name, therefore the function has an additional parameter: "fromElement"
		;it examines whether the element specified here is contained in the ClassNN, eg. Button in WindowsForms10.BUTTON.app.0.378734a2
		;this function is: case-insensitive
	*/

	WinGet, CtrlList, ControlList, ahk_id %WinID%

	Loop, Parse, CtrlList, `n
	{
			classnn:= A_LoopField
			ControlGetText, Name, %classnn% , ahk_id %WinID%
			If Instr(Name, ElementName, false) and Instr(classnn, fromElement, false)
																				break
			;sleep, 2000
		}
return classNN
}
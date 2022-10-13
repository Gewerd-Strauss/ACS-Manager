UIAgetControlNameByHwnd(_, controlHwnd) {		                                                            	;--

	UIAutomation := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
	DllCall(NumGet(NumGet(UIAutomation+0)+6*A_PtrSize), "Ptr", UIAutomation, "Ptr", controlHwnd, "Ptr*", IUIAutomationElement)
	DllCall(NumGet(NumGet(IUIAutomationElement+0)+29*A_PtrSize), "Ptr", IUIAutomationElement, "Ptr*", automationId)
	ret := StrGet(automationId,, "UTF-16")
	DllCall("oleaut32\SysFreeString", "Ptr", automationId)
	ObjRelease(IUIAutomationElement)
	ObjRelease(UIAutomation)
	return ret
}
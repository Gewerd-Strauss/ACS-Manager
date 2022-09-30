
; Version: 2022.07.06.1
; https://gist.github.com/7cce378c9dfdaf733cb3ca6df345b140

GetUrl(WinTitle*)
{
    active := WinExist("A")
    if !(hWnd := WinExist(WinTitle*))
        return
    ; CLSID_CUIAutomation, IID_IUIAutomation
    IUIAutomation := ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
    ; IUIAutomation::ElementFromHandle
    DllCall(NumGet(NumGet(IUIAutomation+0)+6*A_PtrSize), "Ptr",IUIAutomation, "Ptr",hWnd, "Ptr*",eRoot:=0)
    WinGetClass wClass
    ; Gecko family
    if (wClass ~= "Mozilla") {
        GetUrl_FindFirst(IUIAutomation, eRoot, 50004, url:="") ; Edit
        url := StrGet(NumGet(url, 8, "Ptr"), "UTF-16")
    ; Chromium-based, active
    } else if (active = hWnd) {
        GetUrl_FindFirst(IUIAutomation, eRoot, 50030, url:="") ; Document
        url := StrGet(NumGet(url, 8, "Ptr"), "UTF-16")
    ; Chromium-based, inactive
    } else {
        eToolbar := GetUrl_FindFirst(IUIAutomation, eRoot, 50021) ; ToolBar
        GetUrl_FindFirst(IUIAutomation, eToolbar, 50004, url:="") ; Edit
        url := StrGet(NumGet(url, 8, "Ptr"), "UTF-16")
        WinGetTitle wTitle
        ; Google Chrome
        if (InStr(wTitle, "- Google Chrome") && url && !(url ~= "^\w+:")) {
            eMenu := GetUrl_FindFirst(IUIAutomation, eToolbar, 50011,, 30001) ; MenuItem
            VarSetCapacity(rect, 16, 0)
            ; IUIAutomation::IntSafeArrayToNativeArray
            DllCall(NumGet(NumGet(eMenu+0)+43*A_PtrSize), "Ptr",eMenu, "Ptr",&rect)
            w := (r := NumGet(rect,  8, "Int")) - (l := NumGet(rect, 0, "Int"))
            h := (b := NumGet(rect, 12, "Int")) - (t := NumGet(rect, 4, "Int"))
            url := "http" (w > h*2 ? "" : "s") "://" url
            ObjRelease(eMenu)
        }
        ; Microsoft​ Edge
        static edge := "- Microsoft" Chr(0x200b) " Edge" ; Zero-width space
        if (InStr(wTitle, edge) && url && !(url ~= "^\w+:"))
            url := "http://" url
        ObjRelease(eToolbar)
    }
    ObjRelease(eRoot), ObjRelease(IUIAutomation)
    return url
}

; 30001 = UIA_BoundingRectanglePropertyId
; 30045 = UIA_ValueValuePropertyId
GetUrl_FindFirst(IUIAutomation, Element, ControlTypeId, ByRef PropertyValue := "", PropertyId := 30045) {
    static conditions := {}
    if (conditions.HasKey(ControlTypeId)) {
        condition := conditions[ControlTypeId]
    } else {
        VarSetCapacity(value, 8 + 2 * A_PtrSize), NumPut(3, value, 0, "UShort"), NumPut(ControlTypeId, value, 8, "Ptr")
        (A_PtrSize = 8)
            ; IUIAutomation::CreatePropertyCondition
            ? DllCall(NumGet(NumGet(IUIAutomation+0)+23*A_PtrSize), "Ptr",IUIAutomation, "UInt",30003, "Ptr",&value, "Ptr*",condition:=0)
            : DllCall(NumGet(NumGet(IUIAutomation+0)+23*A_PtrSize), "Ptr",IUIAutomation, "UInt",30003, "UInt64",NumGet(value, 0, "UInt64"), "UInt64",NumGet(value, 8, "UInt64"), "Ptr*",condition:=0)
        conditions[ControlTypeId] := condition
    }
    ; IUIAutomationElement::FindFirst
    DllCall(NumGet(NumGet(Element+0)+5*A_PtrSize), "Ptr",Element, "UInt",0x4, "Ptr",condition, "Ptr*",eFirst:=0)
    if (!eFirst)
        return
    VarSetCapacity(PropertyValue, 8 + 2 * A_PtrSize), NumPut(0, PropertyValue, 0, "UShort"), NumPut(0, PropertyValue, 8, "Ptr")
    ; IUIAutomationElement::GetCurrentPropertyValue
    DllCall(NumGet(NumGet(eFirst+0)+10*A_PtrSize), "Ptr",eFirst, "UInt",PropertyId, "Ptr",&PropertyValue)
    return eFirst
}

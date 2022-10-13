SetLayout(layout, winid) {																;-- set a keyboard layout
    Result := (DllCall("LoadKeyboardLayout", "Str", layout, "UInt", "257"))
    DllCall("SendMessage", "UInt", winid, "UInt", "80", "UInt", "1", "UInt", Result)
}
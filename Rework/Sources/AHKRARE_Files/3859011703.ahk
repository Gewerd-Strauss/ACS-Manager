IndexOfIconResource(Filename, ID) {                                                              	;-- function is used to convert an icon resource id (as those used in the registry) to icon index(as used by ahk)

	;By Lexikos http://www.autohotkey.com/community/viewtopic.php?p=168951
    hmod := DllCall("GetModuleHandle", "str", Filename, "PTR")
    ; If the DLL isn't already loaded, load it as a data file.
    loaded := !hmod
        && hmod := DllCall("LoadLibraryEx", "str", Filename, "PTR", 0, "uint", 0x2)

    enumproc := RegisterCallback("IndexOfIconResource_EnumIconResources","F")
    VarSetCapacity(param,12,0)
    NumPut(ID,param,0)
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "uint", hmod, "uint", 14, "uint", enumproc, "PTR", &param)
    DllCall("GlobalFree", "PTR", enumproc)

    ; If we loaded the DLL, free it now.
    if loaded
        DllCall("FreeLibrary", "PTR", hmod)

    return NumGet(param,8) ? NumGet(param,4) : 0
}
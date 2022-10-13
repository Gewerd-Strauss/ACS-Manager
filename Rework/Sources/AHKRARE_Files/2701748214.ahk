ExtractIcon(Filename, IconNumber, IconSize=0) {                                            	;-- extract icon from a resource file
    static SmallIconSize, LargeIconSize
    if (!SmallIconSize) {
        SysGet, SmallIconSize, 49  ; 49, 50  SM_CXSMICON, SM_CYSMICON
        SysGet, LargeIconSize, 11  ; 11, 12  SM_CXICON, SM_CYICON
    }
    VarSetCapacity(phicon, 4, 0)
    h_icon = 0

    ; If possible, use PrivateExtractIcons, which supports any size of icon.
    if A_OSVersion in WIN_VISTA,WIN_2003,WIN_XP,WIN_2000
    {
        VarSetCapacity(piconid, 4, 0)

        ; MSDN: "... this function is deprecated ..." (oh well)
        ret := DllCall("PrivateExtractIcons"
            , "str", Filename
            , "int", IconNumber-1   ; zero-based index of the first icon to extract
            , "int", IconSize
            , "int", IconSize
            , "str", phicon         ; pointer to an array of icon handles...
            , "str", piconid        ; piconid - won't be used
            , "uint", 1             ; nIcons - number of icons to extract
            , "uint", 0, "uint")    ; flags

        if (ret && ret != 0xFFFFFFFF)
            h_icon := NumGet(phicon)
    }
    else
    {   ; Use ExtractIconEx, which only returns 16x16 or 32x32 icons.
        VarSetCapacity(phiconSmall, 4, 0)

        ; Extract the icon from an executable, DLL or icon file.
        if DllCall("shell32.dll\ExtractIconExA"
            , "str", Filename
            , "int", IconNumber-1   ; zero-based index of the first icon to extract
            , "str", phicon         ; pointer to an array of icon handles...
            , "str", phiconSmall
            , "uint", 1)
        {
            ; Use the best-fit size; clean up the other.
            if (IconSize <= SmallIconSize) {
                DllCall("DestroyIcon", "uint", NumGet(phicon))
                h_icon := NumGet(phiconSmall)
            } else {
                DllCall("DestroyIcon", "uint", NumGet(phiconSmall))
                h_icon := NumGet(phicon)
            }
        }
    }

    return h_icon
}
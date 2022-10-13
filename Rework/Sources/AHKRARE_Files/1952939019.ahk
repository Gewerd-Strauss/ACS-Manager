EnumClipFormats() {																            			;--
    FmtArr := [], DllCall( "OpenClipboard" )

    While ( DllCall( "CountClipboardFormats" ) >= a_index )
        FmtArr.Push( fmt := DllCall( "EnumClipboardFormats", uint, a_index = 1 ? 0 : fmt ) )

    Return FmtArr
}
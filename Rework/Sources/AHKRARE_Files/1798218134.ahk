GetHTMLFragment() {																            			;--

    FmtArr := EnumClipFormats(), NmeArr := GetClipFormatNames( FmtArr )

    While ( a_index <= NmeArr.Length() && !ClpPtr )
        if ( NmeArr[ a_index ] = "HTML Format" )
            ClpPtr := DllCall( "GetClipboardData", uInt, FmtArr[ a_index ] )

    DllCall( "CloseClipboard" )

    if ( !ClpPtr )
    {
        MsgBox, 0x10, Whoops!, Please Copy Some HTML From a Browser Window!
        Exit
    }

    Return ScrubFragmentIdents( StrGet( ClpPtr, "UTF-8" ) )
}
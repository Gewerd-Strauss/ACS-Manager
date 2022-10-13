GetClipFormatNames( FmtArr ) {													            	;--
    if ( FmtArr.Length() = False )
    {
        DllCall( "CloseClipboard" )
        Throw "Empty Clipboard Format Array!"
    }

    For Each, Fmt in ( FmtArr, FmtNmArr := [], VarSetCapacity( Buf, 256 ) )
    {
StringMD5( ByRef V, L = 0 ) {               											;-- String MD5 Hashing

    VarSetCapacity( MD5_CTX, 104, 0 ), DllCall( "advapi32\MD5Init", Str, MD5_CTX )
    DllCall( "advapi32\MD5Update", Str, MD5_CTX, Str, V, UInt, L ? L : VarSetCapacity( V ) )
    DllCall( "advapi32\MD5Final", Str, MD5_CTX )
    Loop % StrLen( Hex := "123456789ABCDEF0" )
        N := NumGet( MD5_CTX, 87+A_Index, "Char" ), MD5 .= SubStr( Hex, N>>4, 1 ) . SubStr( Hex, N&15, 1 )
return MD5
}
Base2Dec( _Number, _Base = 16 ) {           										;-- Decimal to Base conversion
    Loop, Parse, _Number
        _N += ( ( A_LoopField * 1 = "" ) ? Asc( A_LoopField ) - 87 : A_LoopField ) * _Base**( Strlen( _Number ) - A_index )
    return _N
}
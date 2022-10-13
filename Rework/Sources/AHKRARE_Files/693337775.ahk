Dec2Base( _Number, _Base = 16 ) {         										 ;-- Base to Decimal and
    Loop % _BaseLen := _Base<10 ? Ceil( ( 10/_Base ) * Strlen( _Number ) ) : Strlen( _Number )
        _D := Floor( _Number/( T := _Base**( _BaseLen-A_index ) ) ), _B .= !_D ? 0: ( _D>9 ? Chr( _D + 87 ) : _D ), _Number := _Number - _D * T
    return Ltrim( _B, "0" )
}
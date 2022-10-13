getHBMinfo( hBM ) {                                                                                           	;--
Local SzBITMAP := ( A_PtrSize = 8 ? 32 : 24 ),  BITMAP := VarSetCapacity( BITMAP, SzBITMAP )
  If DllCall( "GetObject", "Ptr",hBM, "Int",SzBITMAP, "Ptr",&BITMAP )
    Return {  Width:      Numget( BITMAP, 4, "UInt"  ),  Height:     Numget( BITMAP, 8, "UInt"  )
           ,  WidthBytes: Numget( BITMAP,12, "UInt"  ),  Planes:     Numget( BITMAP,16, "UShort")
           ,  BitsPixel:  Numget( BITMAP,18, "UShort"),  bmBits:     Numget( BITMAP,
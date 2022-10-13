HelpToolTips( _Delay = 300, _Duration = 0 ) {                                                       		;--  To show defined GUI control help tooltips on hover.
    _fn := Func( "WM_MOUSEMOVE" ).Bind( _Delay, _Duration )
    OnMessage( 0x200, _fn )
}
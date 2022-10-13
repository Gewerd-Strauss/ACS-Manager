GetStockObject(nr) {                                                                                                    	;--subfunction of GetFontTextDimension()

return DllCall( "GetStockObject", UInt, nr)
}
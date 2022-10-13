FileWriteLine( _File, _Data = "", _Linenum = 1, _Replace = true ) {                                                                         		;-- to write data at specified line in a file.

    FileRead, _FileData, % _File
    _DataBefore := Substr( _FileData, 1, Instr( _FileData, "`r`n", false, 1, _Linenum - 1 ) )
    _DataAfter := Substr( _FileData, Instr( _FileData, "`r`n", false, 1, ( _Replace ? _Linenum : _Linenum - 1 ) ) )
    _FileData := _DataBefore . _Data . _DataAfter
    FileDelete, % _File
    FileAppend, % _FileData, % _File
}
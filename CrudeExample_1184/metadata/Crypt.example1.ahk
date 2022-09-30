#Include <Crypt>

MsgBox % Crypt.Hash.String("SHA1", "The quick brown fox jumps over the lazy dog")
; -> 2fd4e1c67a2d28fced849ee1bb76e7391b93eb12

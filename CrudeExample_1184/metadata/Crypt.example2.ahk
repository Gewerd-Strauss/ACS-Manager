#Include <Crypt>

MsgBox % Crypt.Hash.HMAC("SHA256", "The quick brown fox jumps over the lazy dog", "Secret Salt")
; -> 68dba4b3a6d5c36b6e3567e1a925fe87c7386162e8fb6e2e9f17ade4aa7dc262

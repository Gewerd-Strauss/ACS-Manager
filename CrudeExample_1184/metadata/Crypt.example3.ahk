#Include <Crypt>

MsgBox % Crypt.Hash.File("SHA256", "C:\Program Files\AutoHotkey\AutoHotkey.exe")
; -> c93fde911140a7330f6d2d89bdb8e011b86153b43d64c7e2b66a741abacf9472

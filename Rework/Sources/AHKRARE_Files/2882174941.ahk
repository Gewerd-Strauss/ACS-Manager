GetSysErrorText(errNr) { 																						;-- method to get meaningful data out of the error codes

  bufferSize = 1024 ; Arbitrary, should be large enough for most uses
  VarSetCapacity(buffer, bufferSize)
  DllCall("FormatMessage"
     , "UInt", FORMAT_MESSAGE_FROM_SYSTEM := 0x1000
     , "UInt", 0
     , "UInt", errNr
     , "UInt", 0  ;LANG_USER_DEFAULT := 0x20000 ; LANG_SYSTEM_DEFAULT := 0x10000
     , "Str", buffer
     , "UInt", bufferSize
     , "UInt", 0)
  Return buffer
}
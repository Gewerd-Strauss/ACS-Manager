FormatByteSize(Bytes) {                                                              		;-- give's back the given bytes in KB, MB, GB ....(for AHK_V2)
  static size:="bytes,KB,MB,GB,TB,PB,EB,ZB,YB"
  LoopParse,%size%,`,
    If bytes>999,bytes/=1024
    else if bytes:=RTrim(SubStr(bytes,1,4),".") " " A_LoopField,break
  return bytes
}
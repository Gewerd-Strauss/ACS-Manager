GetFileFormat(file) {                                                                                                                                                 	;-- retreaves the codepage format of a file

  static BOM:={254_255:"UTF-16 BE",255_254:"UTF-16 LE",239_187_191:"UTF-8",247_100_76:"UTF-1",14_254_255:"SCSU",251_238_40:"BOCU-1"
              ,0_0_254_255:"UTF-32 BE",255_254_0_0:"UTF-32 LE",43_47_118_43:"UTF-7",43_47_118_47:"UTF-7",43_47_118_56:"UTF-7"
              ,43_47_118_57:"UTF-7",221_115_102_115:"UTF-EBCDIC",132_49_149_51:"GB 18030"}
  If !FileExist(file)
		return
	FileRead,text,*c %file%

  BOM2:=NumGet(&text,"UChar") "_" NumGet(&text+1,"UChar"), BOM3:=BOM2 "_" NumGet(&text+2,"UChar"), BOM4:=BOM3 "_" NumGet(&text+3,"UChar")
  If BOM.HasKey(BOM4)
    return BOM[BOM4]
  else if BOM.HasKey(BOM3)
    return BOM[BOM3]
  else if BOM.HasKey(BOM2)
    return BOM[BOM2]
  FileGetSize,size,%file%
  return StrLen(StrGet(&text,"UTF-8"))=size?"ANSI":"UTF-8 no BOM"
}
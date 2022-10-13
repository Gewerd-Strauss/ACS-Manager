GetFontNamesFromFile(FontFilePath) {                                                                      	;-- get's the name of a font from a .ttf-FontFile
   If !(Font := FileOpen(FontFilePath, "r")) {
      MSgBox, 16, %A_ThisFunc%, Error: %A_LastError%`n`nCould not open the file`n%FontFilePath%!
      Return ""
   }
   ; Get the number of tables ------------------------------------------------------------------------------------------------------
   Font.Pos += 4
   NumTables := ReadUShortBE(Font)
   ; Search for the 'name' table ---------------------------------------------------------------------------------------------------
   NameTableOffset := 0
   Font.Pos := 12 ; start of table entries
   NextTableEntry := Font.Pos
   Loop, %NumTables% {
      Font.Pos := NextTableEntry
      NextTableEntry += 16 ; size of a table entry
      Font.RawRead(TableName, 4)
      Name 
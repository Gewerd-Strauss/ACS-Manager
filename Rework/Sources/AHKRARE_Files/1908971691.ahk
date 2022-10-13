FileGetDetail(FilePath, Index) { 															                                                                    	;-- Get specific file property by index
   Static MaxDetails := 350
   SplitPath, FilePath, FileName , FileDir
   If (FileDir = "")
      FileDir := A_WorkingDir
   Shell := ComObjCreate("Shell.Application")
   Folder := Shell.NameSpace(FileDir)
   Item := Folder.ParseName(FileName)
   Return Folder.GetDetailsOf(Item, Index)
}
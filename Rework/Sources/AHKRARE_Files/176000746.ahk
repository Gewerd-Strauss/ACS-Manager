FileGetDetails(FilePath) { 																	                                                                    	;-- Create an array of concrete file properties
   Static MaxDetails := 350
   Shell := ComObjCreate("Shell.Application")
   Details := []
   SplitPath, FilePath, FileName , FileDir
   If (FileDir = "")
      FileDir := A_WorkingDir
   Folder := Shell.NameSpace(FileDir)
   Item := Folder.ParseName(FileName)
   Loop, %MaxDetails% {
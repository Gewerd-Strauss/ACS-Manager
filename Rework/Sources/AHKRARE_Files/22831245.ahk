CountFiles(Folder) {                                                                                                                                                 	;-- count files in specific folder (uses COM method)
	fso := ComObjCreate("Scripting.FileSystemObject")
	Folder := fso.GetFolder(Folder)
	return fso.GetFolder(Folder).Files.Count
}
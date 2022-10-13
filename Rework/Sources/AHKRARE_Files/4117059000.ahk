CountFilesR(Folder) {																			                                                                    	;-- count files recursive in specific folder (uses COM method)
	static Counter=0,  fso
	fso := fso?fso:ComObjCreate("Scripting.FileSystemObject")
	Folder := fso.GetFolder(Folder)	, Counter += Counter?0:CountFiles(Folder.path)
	For Subfolder in Folder.SubFolders
		Counter += CountFiles(Subfolder.path) , CountFilesR(Subfolder.path)
	return Counter
}
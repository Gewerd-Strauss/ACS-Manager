CreateOpenWithMenu(FilePath, Recommended := True, 					                                                                    	;-- creates an 'open with' menu for the passed file.
ShowMenu := False, MenuName := "OpenWithMenu", Others := "Others") {

	; ==================================================================================================================================
	; Creates an 'open with' menu for the passed file.
	; Parameters:
	;     FilePath    -  Fully qualified path of a single file.
	;     Recommended -  Show only recommended apps (True/False).
	;                    Defau
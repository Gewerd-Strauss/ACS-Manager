ExtractAssociatedIcon(ByRef ipath, ByRef idx) {									                                                                    	;-- Extracts the associated icon's index for the file specified in path

	; http://msdn.microsoft.com/en-us/library/bb776414(VS.85).aspx
	; shell32.dll
	; Extracts the associated icon's index for the file specified in path
	; Requires path and icon index
	; Icon must be destroyed when no longer needed (see below)

		hInst=0	; reserved, must be zero
	
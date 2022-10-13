ExtractAssociatedIconEx(ByRef ipath, ByRef idx, ByRef iID) {				                                                                    	;-- Extracts the associated icon's index and ID for the file specified in path

		; http://msdn.microsoft.com/en-us/library/bb776415(VS.85).aspx
		; shell32.dll
		; Extracts the associated icon's index and ID for the file specified in path
		; Requires path, icon index and ID
		; Icon must be destroyed when no longer needed (see below)

			hInst=0	; reserved, must be zero
			hIcon := DllCall("ExtractAssociatedIconEx", "UInt", hInst, "UInt", &ipath, "USh
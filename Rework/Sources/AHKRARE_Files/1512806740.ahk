Edit_VCenter(HEDIT) {																						;-- Vertically Align Text for edit controls

	; by just me, http://ahkscript.org/boards/viewtopic.php?f=5&t=4673#p44099
	; the Edit control must have the ES_MULTILINE style (0x0004 \ +Multi)!
	; EM_GETRECT := 0x00B2 <- msdn.microsoft.com/en-us/library/bb761596(v=vs.85).aspx
	; EM_SETRECT := 0x00B3 <- msdn.microsoft.com/en-us/library/bb761657(v=vs.85).aspx

	VarSetCapacity
Space(Width) {                                                                              	;-- generates a string containing only spaces
	Loop, % Width
		Space.= Chr(32)
Return Space
}
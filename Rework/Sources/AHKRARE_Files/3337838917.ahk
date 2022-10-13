GetFileAttributes(Filename, ByRef Attrib := "", ByRef Path := "", ByRef Type := "") {											    	;-- get attributes of a file or folder

	/*                              	DESCRIPTION

			get attributes of a file or folder
			Syntax: GetFileAttributes ([File / Folder], [out Attrib], [out Path], [out Type])
			Parameters:
			Attrib: returns a value that reproduces the attributes.
			Path: returns the complete path.
			Type: if it is a file, it returns "F", if it is a directory it returns "D".
			Return:
			0 = ERROR
			[attributes] = OK
			R = read only
			A = file | modified
			S = system
			H = hidden
			N = normal
			O = offline
			T = temporary
			C = compressed
			D = directory | binder
			E = encrypted
			V = virtual

	*/
	Path := GetFullPathName(Filename), Path := (StrLen(Path) > 260 ? "\\?\" : "") Path (StrLen(Path) > 2 ? "" : "\")
	if ((Attrib := DllCall("Kernel32.dll\GetFileAttributesW", "Ptr", &Path)) = -1)
		return false
	for k, v in {"R": 0x1, "A": 0x20, "S": 0x4, "H": 0x2, "N": 0x80, "D": 0x10, "O": 0x1000, "C": 0x800, "T": 0x100, "E": 0x4000, "V": 0x10000}
		if (Attrib & v)
			OutputVar .= k
	if IsByRef(Type)
		Type := Attrib&0x10?"D":"F"
	return OutputVar
}
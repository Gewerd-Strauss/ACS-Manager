SetFileAttributes(Attributes, Filename, Mode := "FD") {																								;-- set attributes of a file or folder

	/*                              	DESCRIPTION

				change attribute (s) to folder (s) and / or file (s).
				Syntax: SetFileAttributes ([/ - / Attrib], [Filename], [Mode])
				Parameters:
				Mode: F = include files | D = include directories | R = include subdirectories.
				Attrib:
FindFreeFileName(FilePath) {																                                                                    	;-- Finds a non-existing filename for Filepath by appending a number in brackets to the name

	SplitPath, FilePath,, dir, extension, filename
	Testpath := FilePath ;Return path if it doesn't exist
	i := 1
	while FileExist(TestPath)
	{
		i++
		Testpath := dir "\" filename " (" i ")" (extension = "" ? "" : "." extension)
	}
	return TestPath
}
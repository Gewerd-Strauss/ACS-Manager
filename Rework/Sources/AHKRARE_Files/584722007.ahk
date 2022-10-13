DirExist(dirPath) {																				                                                                    	;-- Checks if a directory exists
   return InStr(FileExist(dirPath), "D") ? 1 : 0
}
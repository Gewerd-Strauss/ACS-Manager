IsFileEqual(filename1, filename2) { 														                                                                    	;-- Returns whether or not two files are equal
    ;TODO make this work for big files, too (this version reads it all into memory first)
   FileRead, file1, %filename1%
   FileRead, file2, %filename2%

   return file1==file2
}
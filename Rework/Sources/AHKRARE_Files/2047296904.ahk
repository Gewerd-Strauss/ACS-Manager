FileCount(filter) {																					                                                                    	;-- count matching files in the working directory

   loop,files,%filter%
     Count := A_Index
   return Count
}
ParseJsonStrToArr(json_data) {														;-- Parse Json string to an array
   arr := []
   pos :=1
   While pos:=RegExMatch(json_data,"((?:{)[\s\S][^{}]+(?:}))", j, pos+StrLen(j))
   {
	arr.Insert(j1)                      ; insert json string to array  arr=[{"id":"a1","subject":"s1"},{"id":"a2","subject":"s2"},{"id":"a3","subject":"s3"}]
   }
   return arr
}
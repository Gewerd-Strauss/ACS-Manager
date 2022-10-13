KeyValueObjectFromLists(keyList, valueList, delimiter:="`n"          	;-- merge two lists into one key-value object, useful for 2 two lists you retreave from WinGet
, IncludeKeys:="", KeyREx:="", IncludeValues:="", ValueREx:="") {
	keyArr:= valueArr:= []
	merged:= Object()
	mustMatches:=0

	If !(IncludeKeys="")
			mustMatches+=1
	If !(IncludeValues="")
			mustMatches+=1

	keyArr:= List2Array(keyList, delimiter)
	valueArr:= List2Array(valueList, delimiter)

	Loop % keyArr.Count()
	{
				If (KeyREx="")
					mkey:= keyArr[A_Index]
				else
					RegExMatch(keyArr[A_Index], KeyREx, mkey)

				If (ValueREx="")
					mval:= valueArr[A_Index]
				else
					RegExMatch(valueArr[A_Index], ValueREx, mval)

				If mkey in %IncludeKeys%
					matched:= 1
				else
					matched:= 0

				If mval in %IncludeValues%
					matched += 1

				If (matched=mustMatches) {
						merged[(keyArr[A_Index])]:= valueArr[A_Index]
				}
	}

return merged
}
GetNestedTag(data,tag,occurrence="1") {										;--

	; AHK Forum Topic : http://www.autohotkey.com/forum/viewtopic.php?t=77653
   ; Documentation   : http://www.autohotkey.net/~hugov/functions/GetNestedTag.html

	 Start:=InStr(data,tag,false,1,occurrence)
	 RegExMatch(tag,"i)<([a-z]*)",basetag) ; get yer basetag1 here
	 Loop
		{
		 Until:=InStr(data, "</" basetag1 ">", false, Start, A_Index) + StrLen(basetag1) + 3
 		 Strng:=SubStr(data, Start, Until - Start)

		 StringReplace, strng, strng, <%basetag1%, <%basetag1%, UseErrorLevel ; start counting to make match
		 OpenCount:=ErrorLevel
		 StringReplace, strng, strng, </%basetag1%, </%basetag1%, UseErrorLevel
		 CloseCount:=ErrorLevel
		 If (OpenCount = CloseCount)
		 	Break

		 If (A_Index > 250) ; for safety so it won't get stuck in an endless loop,
		 	{                 ; it is unlikely to have over 250 nested tags
		 	 strng=
		 	 Break
		 	}
		}
	 If (StrLen(strng) < StrLen(tag)) ; something went wrong/can't find it
	 	strng=
	 Return strng
}
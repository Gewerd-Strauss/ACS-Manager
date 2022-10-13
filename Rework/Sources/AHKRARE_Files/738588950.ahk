SetWidth(Str, Width, AlignText) {                                                	;-- increases a string's length by adding spaces to it and aligns it Left/Center/Right
	If (AlignText!=0 and AlignText!=1 and AlignText!=2)
			AlignText:=0

	if AlignText = 0
	{
			RetStr	:= Str . Space(Width)
			RetStr	:= SubStr(RetStr, 1, Width)
	 }
	else If AlignText = 1
	{
			Spaces	:= Width - StrLen(Str)
			RetStr	:= Space(Round(Spaces/2)) . Str . Space(Spaces- Round(Spaces/2))
	}
	else if AlignText = 2
	{
			RetStr	:= Space(Width) . Str
			RetStr	:= SubStr(RetStr, -Width)
	}

Return RetStr
}
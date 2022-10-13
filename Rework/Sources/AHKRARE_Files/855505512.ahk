SetFileTime(Time := "", FilePattern := "", WhichTimeMCA := "M", OperateOnFolders := false, Recurse := false) {		;-- to set the time
	if IsObject(Time)
		for k, v in Time
			FileSetTime, %v%, %FilePattern%, % k=1?"M":k=2?"C":k=3?"A":k, %OperateOnFolders%, %Recurse%
	else Loop, Parse, % WhichTimeMCA
		FileSetTime, %Time%, %FilePattern%, %A_LoopField%, %OperateOnFolders%, %Recurse%
	return !ErrorLevel
}
CreateDDMenu(MenuDefinitionVar, MenuName="MyMenu", MenuSub="MenuSub",ReturnMenu="") {		; by Learning one
	; With CreateDDMenu(), you can easily create drop-down menus by using indentation - %A_Tab%.
	; Line without tabs on the left creates item in main menu. One tab on the left creates subitem, two tabs sub-sub item, and so on.
	; To create separator, specify at least 3 minuses --- (but follow indentation).
	; ReturnMenu parameter: if 1, function will not actually create menu, but will return its definition. You can redirect that return
	; to clipboard and paste your menu in script.
	
	Level0MenuName := MenuName, LabOrSub := MenuSub, MaxDepth := 0
	Loop, parse, MenuDefinitionVar, `n
	{
		CurLevel := 0, Field := A_LoopField
		if Field is space						; blank
		Continue
		while (SubStr(Field,0,1) = A_space or SubStr(Field,0,1) = A_Tab or SubStr(Field,0,1) = "`r")
		StringTrimRight, Field, Field, 1
		var := Field
		while (SubStr(var,1,1) = A_Tab)
		{
			StringTrimLeft, var, var, 1
			CurLevel++
		}
		if (MaxDepth < CurLevel)
		MaxDepth := CurLevel
		lplus := CurLevel + 1, Level%lplus%MenuName := var, CurMenuName := Level%CurLevel%MenuName
		Level%CurLevel%ic .= CurMenuName "|" var "|" LabOrSub "`n"
		if (CurLevel > 0)
		{
			lminus := CurLevel - 1, icToChange := Level%lminus%ic
			StringTrimRight, icToChange, icToChange, 1
			LastLineLen := "", LastLine := ""
			Loop
			{
				LastChar := SubStr(icToChange,0,1)
				if (LastChar = "`n" or LastChar = "")
				break
				else
				{
					LastLine := LastChar LastLine
					StringTrimRight, icToChange, icToChange, 1
				}
			}
			StringSplit, v, LastLine, |
			LastLine := v1 "|" v2 "|:" v2 "`n"
			icToChange .= LastLine
			Level%lminus%ic := icToChange
		}
	}
	MaxDepth += 1
	Loop, %MaxDepth%
	{
		if A_index = 1
		CurLevel := MaxDepth - 1
		else
		CurLevel -= 1
		CurIc := Level%CurLevel%ic
		While (SubStr(CurIc,0) = "`n")
		StringTrimRight, CurIc, CurIc, 1
		if ReturnMenu
		{
			Loop, %CurLevel%
			Indentation .= A_Tab
		}
		Loop, parse, CurIc, `n
		{
			StringSplit, v, A_LoopField, |
			if ReturnMenu
			{
				if (SubStr(v2,1,3) = "---")
				ToReturn .= Indentation "Menu, " v1 ", add`n"
				else
				ToReturn .= Indentation "Menu, " v1 ", add, " v2 ", " v3 "`n"
			}	
			else
			{
				if (SubStr(v2,1,3) = "---")
				Menu, %v1%, add
				else
				Menu, %v1%, add, %v2%, %v3%
			}
		}
		Indentation := ""
	}
	if ReturnMenu
	{
		While (SubStr(ToReturn,0) = "`n")
		StringTrimRight, ToReturn, ToReturn, 1
		return ToReturn
	}
}
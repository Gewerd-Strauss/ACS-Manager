CreateMenu(MenuDefinitionVar, MenuName="MyMenu", 										;-- creates menu from a string in which each item is placed in new line and hierarchy is defined by Tab character on the left (indentation)
MenuSub="MenuSub") {
	MenuNames := {}, ItemNames := {}, Items := {}, BaseMenuName := MenuName, Depth := 0, LastLevel := 1
	Loop, parse, MenuDefinitionVar, `n, `r
	{
		if A_LoopField is space							; ignore
			continue
		ItemInfo := RTrim(A_LoopField, A_Space A_Tab), ItemInfo := LTrim(ItemInfo, A_Space), Level := 1		; refine, reset
		While (SubStr(ItemInfo,1,1) = A_Tab)			; get current Level and ItemInfo
			Level += 1,	ItemInfo := SubStr(ItemInfo, 2)
		RegExMatch(ItemInfo,  "([^`t]*)([`t]*)([^`t]*)", match)		; match1 = ItemName, match3 = ItemIconOptions
		ItemName := Trim(match1), ItemIconOptions := Trim(match3)	; ItemIconOptions exa:  %A_AhkPath%|1|48
		if (IsObject(Items["L" Level]) = 0)				; if object which will contain items for this level doesn't exist yet
			Items["L" Level] := [], Depth += 1			; create it, and increase Depth of this menu
		if (Level=1)
			MenuName := BaseMenuName					; Exa Level1: "MyMenu"
		else
			MenuName := MenuNames["L" Level-1] "_" ItemNames["L" Level-1]	; Exa Level2: "MyMenu_Edit", Exa Level3: "MyMenu_View_Zoom"
		MenuNames["L" Level] := MenuName, ItemNames["L" Level] := ItemName	; store last
		Items["L" Level].Insert([MenuName, ItemName, MenuSub, ItemIconOptions])	; Insert new item object in this level. Item structure: [MenuName,ItemName,LabelOrSubmenu,ItemIconOptions]
		if (Level > LastLevel)	; this is the 1. item in submenu - set this menu as last higher item's submenu
			Max := Items["L" Level-1].MaxIndex(), Items["L" Level-1][Max].3 := ":" MenuName	; set this menu as last higher item's submenu. Exa: ":MyMenu_Edit"
		LastLevel := Level	; store last level
	}
	Loop, % Depth
	{
		Level := (A_index = 1) ? Depth : Depth - A_Index + 1		; from reverse - from deepest to highest level
		For k,v in Items["L" Level]	; v = item. Item structure: [MenuName,ItemName,LabelOrSubmenu,ItemIconOptions] ; MsgBox % v.1 "`n" v.2 "`n" v.3 "`n" v.4
		{
			if (SubStr(v.2, 1, 3) = "---")	; this is a separator
				Menu, % v.1, Add			; Menu, MenuName, add
			else {							; normal item
				if (v.4 = "")				; no ItemIconOptions
					Menu, % v.1, Add, % v.2, % v.3	; Menu, MenuName, add, ItemName, LabelOrSubmenu
				else {						; with ItemIconOptions. v.4 structure: FileName|IconNumber|IconWidth
					ItemIconOptions := v.4	; Exa: %A_AhkPath%|1|48
					Transform, ItemIconOptions, Deref, % ItemIconOptions	; deref things like %A_AhkPath%, %A_ScriptDir%, etc.
					StringSplit, param, ItemIconOptions, |
					Menu, % v.1, Add, % v.2, % v.3													; Menu, MenuName, Add, ItemName, LabelOrSubmenu
					Att := FileExist(param1), Att := (Att = "") ? "" : (InStr(Att, "D") > 0) ? "folder" : "file"	; check is param1 a file
					if (Att="file")
						Menu, % v.1, Icon, % v.2, % Trim(param1), % Trim(param2), % Trim(param3)	; Menu, MenuName, Icon, ItemName, FileName [, IconNumber, IconWidth]
					param1 := "", param2 := "", param3 := ""	; clear for next loop
				}
			}
		}
	}
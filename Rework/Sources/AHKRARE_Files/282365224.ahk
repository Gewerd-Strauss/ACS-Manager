DropShadow(HGUI:="", Style:="", GetGuiClassStyle:="", SetGuiClassStyle:="") {   	;-- Drop Shadow On Borderless Window, (DWM STYLE)
	if (GetGuiClassStyle) {
		ClassStyle:=GetGuiClassStyle()
		return ClassStyle
	}

	if (SetGuiClassStyle) {
		SetGuiClassStyle(HGUI, Style)
	}
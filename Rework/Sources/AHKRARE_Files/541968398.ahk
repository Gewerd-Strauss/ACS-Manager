SplitButton(hButton, GlyphSize=16, Menu="", hDontUse="") {                          	;--	drop down button
	Static       	 _  	:= OnMessage(0x4E, "SplitButton") ;WM_NOTIFY
	Static Menu_	:= "SplitButton_Menu"
	Static hButton_
	If (Menu=0x4E) {

			hCtrl := NumGet(GlyphSize+0, 0, "Ptr") ;-> lParam -> NMHDR -> hCtrl

			If (hCtrl = hButton_) { ;BCN_DROPDOWN for SplitButton

				id := NumGet(GlyphSize+0, A_PtrSize * 2, "uInt")
				If (id = 0xFFFFFB20) {
					ControlGetPos, cX, cY, cW, cH,, ahk_id %hButton_%
					Menu, %Menu_%, Show, % cX+1, % cY + cH
					}
			}
	 } Else {

			If (Menu <> "")
				Menu_ := Menu

			hButton_ := hButton
			Winset,   Style, +0x0C, ahk_id %hButton%          ;BS_SPLITBUTTON
			VarSetCapacity(   pBUTTON_SPLITINFO,  40, 0)
			NumPut(8,         pBUTTON_SPLITINFO,   0, "Int")  ;set glyph size
			NumPut(GlyphSize, pBUTTON_SPLITINFO,  4 + A_PtrSize * 2, "Int")
			SendMessage, BCM_SETSPLITINFO := 0x1607, 0, &pBUTTON_SPLITINFO, , ahk_id %hButton%
			Return

	}
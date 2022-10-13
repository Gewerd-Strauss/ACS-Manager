GetTextSize(pStr, pSize, pFont, pWeight:= 400, pHeight:= false) {						;-- precalcute the Textsize (Width & Height)

  Gui, 55: Font, s%pSize% w%pWeight%, %pFont%
  Gui, 55: Add, Text, R1, %pStr%
  GuiControlGet T, 55: Pos, Static1
  Gui, 55: Destroy
  Return pHeight ? TW "," TH : TW
}
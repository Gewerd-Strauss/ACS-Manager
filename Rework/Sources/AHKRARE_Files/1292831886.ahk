GetUserInput(Default="",Text="",Options="",Control="") {                                	;-- allows you to create custom dialogs that can store different values (each value has a different set of controls)

	; http://ahkscript.org/germans/forums/viewtopic.php?t=7505 by Banane 2015
	/*			Description:
	*/

  ;--- Default Options
  TXT_W := "Input",TXT_D := "Enter a value:",TXT_O := "Apply",TXT_S := "Select a file",TXT_I := "Invalid Input."
  OPT_G := "+Toolwindow -SysMenu +AlwaysOnTop",OPT_V := "Str",OPT_S := "xCenter yCenter w340 h80"
  OPT_T := 255,OPT_R := "",OPT_N := "",OPT_F := "",OPT_I := "0-100",OPT_D := ""

  ;--- Parse value lists
  Loop, Parse, Text, `,, % A_Space
    If (InStr("W,D,O,S,I",SubStr(A_LoopField,1,1)))
      NM := SubStr(A_LoopField,1,1),TXT_%NM% := Su
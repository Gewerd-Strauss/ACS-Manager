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
      NM := SubStr(A_LoopField,1,1),TXT_%NM% := SubStr(A_LoopField,InStr(A_LoopField,"=") + 1,StrLen(A_LoopField))
  Loop, Parse, Options, `,, % A_Space
    If (InStr("G,V,S,T,R,N,F,I,D",SubStr(A_LoopField,1,1)))
      NM := SubStr(A_LoopField,1,1),OPT_%NM% := SubStr(A_LoopField,InStr(A_LoopField,"=") + 1,StrLen(A_LoopField))
  ;--- And retrieved positions keyvalue list
  Loop, Parse, OPT_S, % A_Space, % A_Space
    NM := SubStr(A_LoopField,1,1),VL := SubStr(A_LoopField,2,StrLen(A_LoopField)),POS_%NM% := VL
  ;--- Interpret the control definition
  Loop, Parse, Control, `n, % A_Space
    ;--- Only proceed on valid controls
    If (InStr("Pict,Butt,Text,Grou",SubStr(A_LoopField,1,4))) {
      ;--- Reset arguments variables
      ARG_1 := "",ARG_2 := "",ARG_3 := "",ARG_4 := "",ARG_5 := ""
      ;--- Replace `, temporary (as we parse it with comma)
      Values := RegExReplace(A_LoopField,"\``,","[TEXC]")
      ;--- Parse each param
      Loop, Parse, Values, `,, % A_Space
        ;--- Save argument and restore comma
        ARG_%A_Index% := RegExReplace(A_LoopField,"\[TEXC]",",")
      ;--- Add control to gui
      Gui, 99:Add, % ARG_1, %ARG_3% %ARG_4% g%ARG_5%, % ARG_2
    }

  ;--- Create the dialog
  Gui, 99:%OPT_G% -Resize -MinimizeBox -MaximizeBox +LastFound +LabelGetUserInput_
    Gui, 99:Add, Text, x5 y5 w%POS_W% h15 +BackgroundTrans, % TXT_D
    ;--- Add select button and shorten the edit field
    If (OPT_V = "File") {
      W := POS_W - 35
      Gui, 99:Add, Button, x%W% y25 w30 h20 gGetUserInput_SelectFile, ...
      W := W - 10
    } Else W := POS_W - 10
    ;--- Add the edit field with calculated dimensions
    Gui, 99:Add, Edit, x5 y25 w%W% h20, % Default
    ;--- Disable edit if wanted
    If (SubStr(OPT_D,1,1) = "D" && OPT_V = "File")
      GuiControl, 99:+Disabled, Edit1
    ;--- Create UpDown control for numbers and check edit content
    If (OPT_V = "Num") {
      Gui, 99:Add, UpDown, +Range%OPT_I%, % Value
      GuiControl, 99:+gGetUserInput_CheckEdit, Edit1
    }
    ;--- Calculate button position
    X := (POS_W - 100) / 2,Y := POS_H - 25
    Gui, 99:Add, Button, x%X% y%Y% w100 h20 +Default gGetUserInput_Apply, % TXT_O
  ;--- Show the dialog
  Gui, 99:Show, x%POS_X% y%POS_Y% w%POS_W% h%POS_H%, % TXT_W
  ;--- Apply transparency
  WinSet, Transparent, % OPT_T
  ;--- Apply region
  WinSet, Region, % OPT_R
  ;--- Wait until the dialog is closed
  WinWaitClose
  ;--- And return the input
  Return Edit1

  GetUserInput_CheckEdit:
    ;--- Retrieve the edit's value
    GuiControlGet, Edit1
    ;--- Check if edit's content isn't a numerical value
    If Edit1 is not Number
      ;--- If Type isn't the same as specified "Value" option, apply default
      GuiControl, 99:, Edit1, % Default
    Return

  GetUserInput_Apply:
    ;--- Retrieve the edit's value
    GuiControlGet, Edit1
    GoSub, GetUserInput_Do
    Return

  GetUserInput_SelectFile:
    ;--- Let the user select a file
    FileSelectFile, Value,,, % TXT_S
    ;--- Only apply if a file was selected
    If (Value <> "")
      GuiControl, 99:, Edit1, % Value
    Return

  GetUserInput_Close:
  GetUserInput_Do:
    ;--- Check which value to use
    If (A_GuiControl = TXT_O) {
      GuiControlGet, Edit1
      ;--- Stop if value doesn't complies the requirements
      If (SubStr(OPT_N,1,1) = "N" && Edit1 = "") || (SubStr(OPT_F,1,1) = "F" && FileExist(Edit1) = "") {
        MsgBox, 48, % TXT_W, % TXT_I
        Return
      }
    } Else Edit1 := Default
    ;--- Destroy the window to finish function
    Gui, 99:Destroy
    Return
}
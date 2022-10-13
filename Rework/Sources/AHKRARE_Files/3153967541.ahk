CenterControl(hWnd,hCtrl,X=1,Y=1) {
 static Border,CaptionSmall,CaptionNormal

  ;Retrieve Size of Border and Caption, if this is the first time this function is called
  If (!CaptionNormal) {
    SysGet, Border, 5        ;Border Width
    SysGet, CaptionNormal, 4 ;Window Caption
    SysGet, CaptionSmall, 51 ;Window Caption with Toolwindow Style
  }

  ;Only continue if valid handles passed
  If (!hWnd || !hCtrl)
    Return 0

  ;Retrieve the size of the control and window
  ControlGetPos,,, cW, cH,, % "ahk_id " hCtrl
  WinGetPos,,, wW, wH, % "ahk_id " hWnd
  ;Only continue if the control and window are visible (and don't have a size of 0)
  If ((cW = "" || cH = "") || (wW = "" || wH = ""))
    Return 0

  ;Retrieve the window styles
  WinGet, Styles, Style, % "ahk_id " hWnd
  WinGet, ExStyles, ExStyle, % "ahk_id " hWnd

  ;Calculate the offset
  If (Styles & 0xC00000) ;If window has the "Caption" flag
    If (ExStyles & 0x00000080) ;If window has the "Toolwindow" flag
      Caption := CaptionSmall
    Else Caption := CaptionNormal
  Else Caption := 1

  ;Calculate the new position and apply it to the control
  ControlMove,, % (X = 1) ? Round((wW - cW + Border) / 2) : "", % (Y = 1) ? Round((wH - cH + Caption) / 2) : "",,, % "ahk_id " hCtrl

  ;Redraw the windows content
  WinSet, Redraw,, % "ahk_id " hWnd

  Return 1
}
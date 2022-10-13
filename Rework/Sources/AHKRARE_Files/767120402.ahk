ControlExists(class) {                                                                                                	;-- true/false for ControlClass
  WinGet, WinList, List  ;gets a list of all windows
  Loop, % WinList
  {
    temp := "ahk_id " WinList%A_Index%
    ControlGet, temp, Hwnd,, %class%, %temp%
    if !ErrorLevel  ;errorlevel is set to 1 if control doesn't exist
      return temp
  }
  return 0
}
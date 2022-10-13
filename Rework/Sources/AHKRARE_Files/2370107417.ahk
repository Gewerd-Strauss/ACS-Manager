GetContextMenuID(hWnd, Position) {																		;-- returns the ID of a menu entry
  WinGetClass, WindowClass, ahk_id %hWnd%
  if WindowClass <> #32768
  {
   return -1
  }
  SendMessage, 0x01E1, , , , ahk_id %hWnd%
  ;Errorlevel is set by SendMessage. It contains the handle to the menu
  hMenu := errorlevel

  ;UINT GetMenuItemID(          HMENU hMenu,    int nPos);
  InfoRes := DllCall("user32.dll\GetMenuItemID",UInt,hMenu, Uint, Position)

  InfoResError := errorlevel
  LastErrorRes := DllCall("GetLastError")
  if InfoResError <> 0
     return -1
  if LastErrorRes != 0
     return -1

  return InfoRes
}
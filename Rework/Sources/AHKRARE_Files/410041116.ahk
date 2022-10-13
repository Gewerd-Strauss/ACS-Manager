GetContextMenuState(hWnd, Position) {																	;-- returns the state of a menu entry
  WinGetClass, WindowClass, ahk_id %hWnd%
  if WindowClass <> #32768
  {
   return -1
  }
  SendMessage, 0x01E1, , , , ahk_id %hWnd%
  ;Errorlevel is set by SendMessage. It contains the handle to the menu
  hMenu := errorlevel

  ;We need to allocate a struct
  VarSetCapacity(MenuItemInfo, 60, 0)
  ;Set Size of Struct to the first member
  InsertInteger(48, MenuItemInfo, 0, 4)
  ;Get only Flags from dllcall GetMenuItemInfo MIIM_TYPE = 1
  InsertInteger(1, MenuItemInfo, 4, 4)

  ;GetMenuItemInfo: Handle to Menu, Index of Position, 0=Menu identifier / 1=Index
  InfoRes := DllCall("user32.dll\GetMenuItemInfo",UInt,hMenu, Uint,
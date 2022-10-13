Menu_AssignBitmap(p_menu, p_item, p_bm_unchecked,                                         	;-- assign bitmap to any item in any AHk menu
p_unchecked_face=false, p_bm_checked=false,p_checked_face=false)   {
    static   menu_list, h_menuDummy

    If h_menuDummy=
    {
      menu_list = |

      ; Save current 'DetectHiddenWindows' mode to reset it later
      Old_DetectHiddenWindows := A_DetectHiddenWindows
      DetectHiddenWindows, on

      ; Retrieve scripts PID
      Process, Exist
      pid_this := ErrorLevel

      ; Create menuDummy and assign to Gui99
      Menu, menuDummy, Add
      Menu, menuDummy, DeleteAll

      Gui, 99:Menu, menuDummy

      ; Retrieve menu handle (menuDummy)
      h_menuDummy := DllCall( "GetMenu", "uint", WinExist( "ahk_class AutoHotkeyGUI ahk_pid " pid_this ) )

      ; Remove menu bar 'menuDummy'
      Gui, 99:Menu

      ; Reset 'DetectHiddenWindows' mode to old setting
      DetectHiddenWindows, %Old_DetectHiddenWindows%
    }

    ; Assign p_menu to menuDummy and retrieve menu handle
    If (! InStr(menu_list, "|" p_menu ",", false))
      {
        Menu, menuDummy, Add, :%p_menu%
        menu_ix := DllCall( "GetMenuItemCount", "uint", h_menuDummy ) - 1
        menu_list = %menu_list%%p_menu%,%menu_ix%|
      }
    Else
      {
        menu_ix := InStr(menu_list, ",", false, InStr( menu_list, "|" p_menu ",", false)) + 1
        StringMid, menu_ix, menu_list, menu_ix, InStr(menu_list, "|", false, menu_ix) - menu_ix
      }

    h_menu := DllCall("GetSubMenu", "uint", h_menuDummy, "int", menu_ix)

    ; Load bitmap for unchecked menu entries
    If (p_bm_unchecked)
      {
        hbm_unchecked := DllCall( "LoadImage"
                                , "uint", 0
                                , "str", p_bm_unchecked
                                , "uint", 0                             ; IMAGE_BITMAP
                                , "int", 0
                                , "int", 0
                                , "uint", 0x10|(0x20*p_unchecked_face)) ; LR_LOADFROMFILE|LR_LOADTRANSPARENT

        If (ErrorLevel or ! hbm_unchecked)
          {
             MsgBox, [Menu_AssignBitmap: LoadImage: unchecked] failed: EL = %ErrorLevel%
             Return, false
          }
      }

    ; Load bitmap for checked menu entries
    If (p_bm_checked)
      {
        hbm_checked := DllCall( "LoadImage"
                              , "uint", 0
                              , "str", p_bm_checked
                              , "uint", 0                               ; IMAGE_BITMAP
                              , "int", 0
                              , "int", 0
                              , "uint", 0x10|(0x20*p_checked_face))     ; LR_LOADFROMFILE|LR_LOADTRANSPARENT

        If (ErrorLevel or ! hbm_checked)
          {
             MsgBox, [Menu_AssignBitmap: LoadImage: checked] failed: EL = %ErrorLevel%
             Return, false
          }
      }

    ; On success assign image to menu entry
    success := DllCall( "SetMenuItemBitmaps"
                      , "uint", h_menu
                      , "uint", p_item-1
                      , "uint", 0x400                                   ; MF_BYPOSITION
                      , "uint", hbm_unchecked
                      , "uint", hbm_checked )

    If (ErrorLevel or ! success)
      {
        MsgBox, [Menu_AssignBitmap: SetMenuItemBitmaps] failed: EL = %ErrorLevel%
        Return, false
      }

    Return, true
}
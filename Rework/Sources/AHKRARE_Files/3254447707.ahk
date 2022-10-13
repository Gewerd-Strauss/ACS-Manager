ControlClick2(X, Y, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="")  {		;-- ControlClick Double Click

  hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY
                             , ExcludeTitle, ExcludeText)
  PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDOWN
  PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP
  PostMessage, 0x203, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDBLCLCK
  PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP
}
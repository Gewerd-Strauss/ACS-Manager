IsFullScreen(hwnd) {																									;-- specific window is a fullscreen window?

  WinGet, Style, Style, ahk_id %hwnd%
  return !(Style & 0x40000) ; 0x40000 = WS_SIZEBOX
}
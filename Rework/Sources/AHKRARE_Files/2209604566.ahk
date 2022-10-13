IsOverTitleBar(x, y, hWnd) { 																						;-- WM_NCHITTEST wrapping: what's under a screen point?

	; This function is from http://www.autohotkey.com/forum/topic22178.html
   SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd%
   if ErrorLevel in 2,3,8,9,20,21
      return true
   else
      return false
}
ClipboardGetDropEffect() {																				;-- Clipboard function. Retrieves if files in clipboard comes from an explorer cut or copy operation.

   Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str" , "Preferred DropEffect")
   DropEffect := 0
   If DllCall("IsClipboardFormatAvailable", "UInt", PreferredDropEffect) {
      If DllCall("OpenClipboard", "Ptr", 0) {
         hDropEffect := DllCall("GetClipboardData", "UInt", PreferredDropEffect, "UPtr")
         pDropEffect := DllCall("GlobalLock", "Ptr", hDropEffect, "UPtr")
         DropEffect := NumGet(pDropEffect + 0, 0, "UChar")
         DllCall("GlobalUnlock", "Ptr", hDropEffect)
         DllCall("CloseClipboard")
      }
   }
   Return DropEffect
}
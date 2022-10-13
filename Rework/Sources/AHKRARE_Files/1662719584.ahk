GuiControlLoadImage(HCTRL, PicPath, Rotate = "") {                                         	;-- scale down a picture to fit the given width and height of a picture control
   Global PicW, PicH
   Static STM_GETIMAGE := 0x0173
   Static STM_SETIMAGE := 0x0172
   Static Rotate90FlipNone  := 1
   Static RotateNoneFlipY   := 2
   Static Rotate270FlipNone := 3
   Static RotateNoneFlipX   := 4
   If !(HCTRL + 0)
      GuiControlGet, HCTRL, HWND, %HCTRL%
   If !(HCTRL)
      Return
   DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", PicPath, "PtrP", GDIPBitmap)
   If Rotate Between 1 And 4
      DllCall("Gdiplus.dll\GdipImageRotateFlip", "Ptr", GDIPBitmap, "Int", Rotate)
   DllCall("Gdiplus.dll\GdipGetImageWidth", "Ptr", GDIPBitmap, "UIntP", PW)
   DllCall("Gdiplus.dll\GdipGetImageHeight", "Ptr", GDIPBitmap, "UIntP", PH)
   DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", GDIPBitmap, "PtrP", HBITMAP, "UInt", 0xFFFFFFFF)
   DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", GDIPBitmap)
   W := PW
   H := PH
   If (H > PicH) {
      W := Round(PW * PicH / H)
      H := PicH
   }
   If (W > PicW) {
      H := Round(H * PicW / W)
      W := PicW
   }
   HBITMAP := DllCall("User32.dll\CopyImage", "Ptr", HBITMAP, "UInt", 0, "Int", W, "Int", H, "UInt", 0x08, "UPtr")
   SendMessage, STM_SETIMAGE, 0, HBITMAP, , ahk_id %HCTRL%
   If (ErrorLevel + 0)
      DllCall("Gdi32.dll\DeleteObject", "Ptr", ErrorLevel)
   SendMessage, STM_GETIMAGE, 0, 0, , ahk_id %HCTRL%
   If (ErrorLevel <> HBITMAP)
      DllCall("Gdi32.dll\DeleteObject", "Ptr", HBITMAP)
   Return PW . "|" . PH
}
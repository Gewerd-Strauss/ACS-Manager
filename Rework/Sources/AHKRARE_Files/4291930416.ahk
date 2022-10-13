BlackWhite(pBitmap, ByRef pBitmapOut, Width, Height)       {                           	;-- sub from Convert_BlackWhite
          global blackwhite
          E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
          E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
          R := DllCall(&blackwhite, "uint", Scan01, "uint", Scan02, "int", Width, "int", Height, "int", Stride1)
          Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
          return (R)
}
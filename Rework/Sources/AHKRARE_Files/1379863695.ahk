Gdip_BitmapReplaceColor(pBitmap, ByRef pBitmapOut, Color                           	;-- using Mcode to replace a color with a specific variation
, ReplaceColor, Variation) {
   static BitmapReplaceColor
   if !BitmapReplaceColor
   {
      MCode_BitmapReplaceColor := "83EC248B4424388B4C243C995683E2038BF103C28B542438C1FE10C1F90881E6FF00000081E1FF000000C1F8028"
      . "9742408894C244085D2
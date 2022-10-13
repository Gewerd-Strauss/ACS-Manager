CreateFont(nHeight, nWidth, nEscapement, nOrientation, fnWeight,                        	;-- creates HFont for use with GDI
fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision,
fdwClipPrecision, fdwQuality, fdwPitchAndFamily, lpszFace) {

/*
HFONT CreateFont(
  int nHeight,               // height of font
  int nWidth,                // average character width
  int nEscapement,           // angle of escapement
  int nOrientation,          // base-line orientation angle
  int fnWeight,              // font weight
  DWORD fdwItalic,           // italic attribute option
  DWORD fdwUnderline,        // underline attribute option
  DWORD fdwStrikeOut,        // strikeout attribute option
  DWORD fdwCharSet,          // character set identifier
  DWORD fdwOutputPrecision,  // output precision
  DWORD fdwClipPrecision,    // clipping precision
  DWORD fdwQuality,          // output quality
  DWORD fdwPitchAndFamily,   // pitch and family
  LPCTSTR lpszFace           // typeface name
);
*/

	return DllCall("CreateFont"
				, "Int" , nHeight           , "Int" , nWidth          , "Int" , nEscapement
				, "Int" , nOrientation      , "Int" , fnWeight        , "UInt", fdwItalic
				, "UInt", fdwUnderline      , "UInt", fdwStrikeOut    , "UInt", fdwCharSet
				, "UInt", fdwOutputPrecision, "UInt", fdwClipPrecision, "UInt", fdwQuality
				, "UInt", fdwPitchAndFamily , "Str" , lpszFace)
}
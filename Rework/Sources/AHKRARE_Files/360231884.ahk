PrintStr(Str,FontName:="Arial",FontSize:=10,FontOpts:="") {        	;-- Prints the passed string on the default printer
   Static DISize := A_PtrSize * 5 ; size of DOCINFO structure
   Static DPSize := 20 ; size of DRAWTEXTPARAMS structure
   Static LFSize := A_IsUnicode ? 60 : 92 ; size of LOGFONT structure
   Static PDSize := A_PtrSize = 8 ? (A_PtrSize
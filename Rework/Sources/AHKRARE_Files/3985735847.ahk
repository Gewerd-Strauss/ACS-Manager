IsOfficeFile(FileName, Extensions:= "doc,docx,xls,xlsx,ppt,pptx") { 					;-- checks if a file is an Office file

	;  Last update: 2014-4-23

	static doc  := "57006f007200640044006f00630075006d0065006e0074"                                 ; W.o.r.d.D.o.c.u.m.e.n.t
	,      docx := "00776F72642F"                                                                   ; .word/
	,      xls  := "0057006f0072006b0062006f006f006b00"                                             ; .W.o.r.k.b.o.o.k.
	,      xlsx := "0000786C2F"                                                                     ; ..xl/
	,      ppt  := "0050006f0077006500720050006f0069006e007400200044006f00630075006d0065006e007400" ; .P.o.w.e.r.P.o.i.n.t. .D.o.c.u.m.e.n.t.
	,      pptx := "00007070742F"                                                                   ; ..ppt/

	; =======================================
	; Check first 4 bytes
	; =======================================
	File := FileOpen(FileName, "r")
	File.RawRead(bin, 4)
	MCode_Bin2Hex(&bin, 4, hex)

	; Magic Numbers (http://en.wikipedia.org/wiki/List_of_file_signatures)
	;   doc/xls/ppt: D0CF11E0
	;   zip/jar/odt/ods/odp/docx/xlsx/pptx/apk: 504B0304, 504B0506 (empty archive) or 504B0708 (spanned archive)
	If hex not in D0CF11E0,504B0304,504B0506,504B0708
		Return "", File.Close()

	; =======================================
	; docx/xlsx/pptx --> check last 1024 bytes
	; =======================================
	If hex in 504B0304,504B0506,504B0708
	{
		File.Position := File.Length - 1024
		File.RawRead(bin, 1024)
		File.Close()
		MCode_Bin2Hex(&bin, 1024, hex)

		Loop, Parse, Extensions, CSV, %A_Space%%A_Tab%
			If (  InStr(hex, %A_LoopField%)  )
				Return A_LoopField

		Return
	}

	; =======================================
	; detect doc/xls/ppt
	; Reference: Daniel Rentz. Microsoft Compound Document File Format. 2006-Dec - 21.
	; =======================================
	; SecID of first sector of the directory stream
	File.Position := 48
	File.RawRead(bin, 4)
	MCode_Bin2Hex(&bin, 4, hex)
	SecID1 := "0x" SubStr(hex, 7, 2) SubStr(hex, 5, 2) SubStr(hex, 3, 2) SubStr(hex, 1, 2)
	SecID1 := SecID1 + 0

	; Jump to this offset...
	Offset := 512 * (SecID1 + 1)
	Length := 5 * 128

	File.Position := Offset
	File.RawRead(bin, Length)
	MCode_Bin2Hex(&bin, Length, hex)

	File.Close()

	; detecting...
	Loop, Parse, Extensions, CSV, %A_Space%%A_Tab%
		If (  InStr(hex, %A_LoopField%)  )
			Return A_LoopField
}
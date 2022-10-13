PdfPageCounter(PathToPdfFile){                                                		;-- counts pages of a pdffile (works with 95% of pdf files)

	;https://autohotkey.com/board/topic/90560-pdf-page-counter/
    F:=FileOpen(PathToPdfFile,"r"), FSize:=F.Length, FContents:=F.Read(FSize), F.Close()
    while pos := RegExMatch(FContents, "is)<<[^>]*(/Count[^>]*/Kids|/Kids[^>]*/Count)[^>]*>>", m, (pos?pos:1)+StrLen(m))
	{
		if InStr(m, "Parent")
			continue
		PageCountLine := m
	}
    if !(PageCount := RegExReplace(PageCountLine, "is).*/Count\D*(\d+).*", "$1")) > 0
        while pos  := RegExMatch(FContents, "i)Type\s*/Page[^s/]", m, (pos?pos:1) +StrLen(m))
            PageCount++
    return, PageCount
}
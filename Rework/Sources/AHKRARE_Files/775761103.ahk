AppendToClipboard( files, cut=0) { 																;-- Appends files to CF_HDROP structure in clipboard
	DllCall("OpenClipboard", "Ptr", 0)
	if (DllCall("IsClipboardFormatAvailable", "Uint", 1)) ;If text is stored in clipboard, clear it and consider it empty (even though the clipboard may contain CF_HDROP due to text being copied to a temp file for pasting)
		DllCall("EmptyClipboard")
	DllCall("CloseClipboard")
	txt:=clipboard (clipboard = "" ? "" : "`n") files
	Sort, txt , U ;Remove duplicates
	CopyToClipboard(txt, true, cut)
	return
}
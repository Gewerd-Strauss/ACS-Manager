PdfToText(PdfPath) {																		;-- copies a selected PDF file to memory - it needs xpdf - pdftotext.exe


    static XpdfPath := """" A_ScriptDir "\pdftotext.exe"""
    objShell := ComObjCreate("WScript.Shell")

	
    CmdString := XpdfPath " -table """ PdfPath """ -"
    objExec := objShell.Exec(CmdString)
    while, !objExec.StdOut.AtEndOfStream ; Wait for the program to finish
        strStdOut := objExec.StdOut.ReadAll()
    return strStdOut
}
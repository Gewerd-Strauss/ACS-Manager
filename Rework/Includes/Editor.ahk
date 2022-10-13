










EditorImporter(Snippet:="",SnippetsStructure:="",ConvertingAHKRARE:=false)
{
    gui, ACSI: destroy
    gui, ACSI: new, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border +labelACSI -Resize ;+Owner1 ;+MinSize1000x		
    gui, ACSI: default
    gui, +hwndACSIGUI
    if WinExist("ahk_exe code.exe") || (A_DebuggerName="Visual Studio Code")
        gui, ACSI: -AlwaysOnTop
    gui_control_options := "xm w220 " . cForeground . " -E0x200"  ; remove border around edit field
    , gui_control_options2 :=  cForeground . " -E0x200"
    , cBackground := "c" . "1d1f21"
    , cCurrentLine := "c" . "282a2e"
    , cSelection := "c" . "373b41"
    , cForeground := "c" . "c5c8c6"
    , cComment := "c" . "969896"
    , cRed := "c" . "cc6666"
    , cOrange := "c" . "de935f"
    , cYellow := "c" . "f0c674"
    , cGreen := "c" . "b5bd68"
    , cAqua := "c" . "8abeb7"
    , cBlue := "c" . "81a2be"
    , cPurple := "c" . "b294bb"
    , vLastCreationScreenHeight:=vGuiHeight2  
    , vLastCreationScreenWidth:=vGUIWidth2
    gui, font, s9 cRed, Segoe UI
    SysGet, Mon,MonitorWorkArea 
    Height:=MonBottom
    if (!vGUIWidth2 and !vGuiHeight2) || (((vGUIWidth2!=(A_ScreenWidth-20)) || (vGuiHeight2!=(A_ScreenHeight))) && !bSwitchSize) ; assign outer gui dimensions either if they don't exist or if the resolution of the active screen has changed - f.e. when undocking or docking to a higher resolution display. The lGuiCreate_1-subroutine is also invoked in total if the resolution changes, but this is the necessary inner check to reassign dimensions.
    { 
        vGUIWidth2:=A_ScreenWidth*1.0 - 20  ;-910 ; 0.6@1440 starts clipping
        , vGuiHeight2:=MonBottom*1.0 - 20 
    }
    EditWidth:=vGUIWidth2-2*15
    , EditHeight:=(vGuiHeight2>1100)?vGuiHeight2*0.25+30 : vGuiHeight2*0.225+30
    , SmallFieldsStart:=EditHeight*3+25
    , SmallFieldsHeight:=(vGuiHeight2-EditHeight*3)/9
    , LicenseFieldsHeight:=(vGuiHeight2-EditHeight*3+20)/9
    if !IsObject(Snippet) && (Snippet!="Ingestion")
    {

        ; Gui +OwnDialogs
        MsgBox 0x40030, % script.name " - Snippet Editor", The contents fed to be edited do not resemble a valid snippet object.`n`nPlease check for errors in the data structure`, as well as the source code.`n`nReturning to Main GUI
        return
    }
    bIsEditing:=(IsObject(Snippet)?true:false)
    if Snippet.Metadata.HasKey("Date") 
    {
        if (script.config.Settings.DateFormat!="")
            FormatTime, Date,% Snippet.Metadata.Date, % script.config.Settings.DateFormat
        else
            FormatTime, Date,% Snippet.Metadata.Date, % "yyyyMMdd"
        if (Date="") && (Snippet.Metadata.Date!="")
        {
            Date:=snippet.Metadata.Date
        }

    }
    ImporterSections:=""
    for k,v in SnippetsStructure[2]
    {
        if (v="")
            continue
        ImporterSections.="|" v
    }
        Clipboard:=ImporterSections
    if !Instr(ImporterSections,snippet.MetaData.section)
        ImporterSections.="|" snippet.MetaData.section "|"
    FoundSection:=strreplace(ImporterSections,snippet.metadata.Section,snippet.metadata.Section "|")
    gui, add, edit, w%EditWidth% h%EditHeight% vvSnippet_Importer,% (Snippet.Code!=""?Snippet.Code:"Code")
    gui, add, edit, w%EditWidth% h%EditHeight% vvDesc_Importer, % (Snippet.Description!=""?snippet.Description:"Desc")
    gui, add, edit, w%EditWidth% h%EditHeight% vvEx_Importer, % (Snippet.Example!=""?Snippet.Example:"Ex")
    gui, add, text, y%SmallFieldsStart% xp, Name
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvName_Importer, % snippet.metadata.name
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Author
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvAuthor_Importer, % snippet.metadata.author
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, version
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvVersion_Importer, % snippet.metadata.version
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Date
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvDate_Importer, % Date
    gui, add, text, yp+%SmallFieldsHeight% xp-100, License
    gui, add, ComboBox, yp xp+100 w120 r5 h%SmallFieldsHeight% vvLicense_Importer, % strreplace("MIT|BSD3|Unlicense|WTFPL|none|paste",snippet.metadata.License,snippet.metadata.License "|")
    gui, add, text, yp+%SmallFieldsHeight% xp-100, License URL
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvLicenseURL_Importer, % snippet.metadata.licenseURL
    
    gui, add, text, y%SmallFieldsStart% xp+200, Section
    gui, add, ComboBox, yp xp+100 w120 r5 h%SmallFieldsHeight% vvSection_Importer, % FoundSection
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Source URL
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvURL_Importer, % snippet.metadata.URL
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Library
    
    Ind:=0
        loop, files, % DirectoryPath, D
        {
            Ind++
            ;; todo: make this load from a path in script.settings.path, including scriptObj
            SplitPath,% A_LoopFileFullPath,OutName, OutDir
            OutName:=strsplit(OutName,"\")[strsplit(OutName,"\").MaxIndex()]
            str.=OutName "|" 
            if (Ind=1)
                str.="|"
        }
        libstr:=strreplace(strreplace(str,"||","|"),snippet.metadata.Library,snippet.metadata.Library "|")
        gui, add, ComboBox, yp xp+100 w120 h%SmallFieldsHeight% R100 vvLibrary_Importer,% libstr

    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Dependencies
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvDependencies_Importer, % snippet.metadata.dependencies
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, AHK-Version
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvAHK_Version_Importer, % snippet.metadata.AHK_Version
    gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Keywords   
    gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvKeywords_Importer, % snippet.metadata.KeyWords
    ; gui, add, text, yp+%SmallFieldsHeight%+5 xp-300, Date
    ; gui, add, edit, yp xp+300 w120 h%SmallFieldsHeight% vvDate_Importer2, % Date
    ; gui, add, text, yp+24 xp-300, License
    ; gui, add, ComboBox, yp xp+300 w120 r5 h%SmallFieldsHeight% vvLicense_Importer2, % strreplace("MIT|BSD3|Unlicense|WTFPL|none|paste",snippet.metadata.License,snippet.metadata.License "|")
    ; gui, add, text, yp+%SmallFieldsHeight%+5 xp-300, Section
    ; gui, add, ComboBox, yp xp+300 w120 r5 h%SmallFieldsHeight% vvSection_Importer2, % FoundSection
    ; gui, add, text, yp+%SmallFieldsHeight%+5 xp-300, URL
    ; gui, add, edit, yp xp+300 w120 h%SmallFieldsHeight% vvURL_Importer2, % snippet.metadata.URL
    ; gui, add, text, yp+%SmallFieldsHeight%+5 xp-300, Library
    
    EditWidth2:=EditWidth-220-110
    gui, add, text, yp-195 xp+150, % ""
    ; Obj_SubmitImporter:=Func("fSubmitImporter").Bind(Desc, Ex, vSnippet_Importer, vDesc_Importer, vEx_Importer, SubmissionObj.Name, vAuthor_Importer, vVersion_Importer, vDate_Importer, vLicense_Importer, vSection_Importer, vURL_Importer, vLibrary_Importer, vLicense_ImporterInsert)
    
    gui, add, button, y%SmallFieldsStart% xp+200 h%SmallFieldsHeight% glSubmitImporter, % bIsEditing?"Edit":"Ingest"
    gui, add, button, yp+30 xp h%SmallFieldsHeight% glOpenSnippetInFolder, % "Open in folder"
    gui, add, button, yp+30 xp h%SmallFieldsHeight% glDelete, % "Delete"
    ; gui, add, edit, y%SmallFieldsStart% xp+80 w%EditWidth2% h%LicenseFieldsHeight% r12  vvLicense_ImporterInsert, %  bIsEditing?"[[Insert License if not found in DDL]]":"[[Insert License if not found in DDL]]"
    gui, font, s9 cWhite, Segoe UI
    if !ConvertingAHKRARE
        fGuiShow_2(vGUIWidth2,vGuiHeight2)
    Hotkey, IfWinActive, % "ahk_id " ACSIGUI
    Hotkey, ^Enter,lSubmitImporter
    Hotkey, Esc, fGuiHide_2
    global SnippetClone:=Snippet.Clone()
    if (ConvertingAHKRARE)
    {
        bConvertfromAHKRARE:="ConvertingAHKRARE"
        ; sleep, 200
        gosub, lSubmitImporter
    }
    return
}

fGuiHide_2()
{
    global
    gui, ACSI: hide
    gui, 1: -Disabled
    fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
    return
}

fGuiShow_2(Width,Height)
{
    gui, 1: +Disabled
    gui, 1: hide
    gui, ACSI: show, w%Width% h%Height%, % GuiNameMain
    return
}

lOpenSnippetInFolder:
gui, ACSI: submit, NoHide 
gui, 1: -Disabled
gui, 1: -AlwaysOnTop
fOpenSnippetInFolder(vName_Importer, vLibrary_Importer, vSnippet_Importer)
return

fOpenSnippetInFolder(vName_Importer, vLibrary_Importer, vSnippet_Importer)
{ ;; open the code file already selected in the explorer if one wants to navigate there.
    Key:=vName_Importer . vLibrary_Importer . vSnippet_Importer ;; cuz the hash is no longer required to be translated, I can make it 
    Hash:=Object_HashmapHash(Key) ; Issue: What to include in the hashed snippet name?
    Path:=substr(DirectoryPath,1,Strlen(DirectoryPath)-1)  vLibrary_Importer "\" Hash
    Run Explorer.exe /select`,%Path%.ahk
    gui, 1: +AlwaysOnTop
    return
}

lDelete:
gui, ACSI: submit, NoHide 
gui, 1: -Disabled
if fDelete(SnippetClone)
    reload
else
    MsgBox 0x30, % script.name " - Snippet Editor", "Error:`n" scnippetclone.metadata.name " could not be deleted."
return
fDelete(Snippet)
{ ;; deletes a snippet
    gui, ACSI: submit
    Extensions:=[".ahk",".ini",".example",".description"]
    Success:=0
    Expected:=0
    for k,v in Extensions
    {
        if FileExist(A_ScriptDir "\Sources\" Snippet.Metadata.Library "\" Snippet.Metadata.Hash v)
        {
            Expected++
            FileRecycle, % A_ScriptDir "\Sources\" Snippet.Metadata.Library "\" Snippet.Metadata.Hash v
            if !FileExist(A_ScriptDir "\Sources\" Snippet.Metadata.Library "\" Snippet.Metadata.Hash v)
                Success++
        }
    }
    return (Success>=Expected)?1:0
}

fBackup(vName_Importer, vLibrary_Importer, vSnippet_Importer,Snippet)
{ ;; back up a snippet
    gui, ACSI: submit
    ; Key:=vName_Importer . vLibrary_Importer . vSnippet_Importer ;; cuz the hash is no longer required to be translated, I can make it 
    ; Hash:=Object_HashmapHash(Key) ; Issue: What to include in the hashed snippet name?
    Extensions:=[".ahk",".ini",".example",".description"]
    Success:=0
    Expected:=0
    for k,v in Extensions
    {
        Source:=A_ScriptDir "\Sources\" Snippet.Metadata.Library "\" Snippet.Metadata.Hash v
        Destination:=A_ScriptDir "\Sources\" Snippet.Metadata.Library "\000-BACKUP_" Snippet.Metadata.Hash v
        if FileExist(Source)
        {
            FileCopy,% Source,% Destination,1
            Expected++
        }
        if FileExist(Destination)
            Success++
    }
    return (Success>=Expected)?1:0
}

lSubmitImporter: ;; fucking hell I cannot bind it, I _must_ use a label here cuz I cannot bind to the button itself?
gui, ACSI: submit, 
; SnippetClone
if (snippetClone.Count()!=0) && (SnippetClone!="")
{
    fBackup(snippetclone.Metadata.name, SnippetClone.Metadata.Library, SnippetClone.Code,SnippetClone)
    fDelete(SnippetClone)
}
; global ConvertingAHKRARE:=ConvertingAHKRARE
fSubmitImporter({Snippet:vSnippet_Importer,Description:vDesc_Importer, Example:vEx_Importer, Name:vName_Importer,Author:vAuthor_Importer, Version:vVersion_Importer,Date:vDate_Importer,License:vLicense_Importer,LicenseURL:vLicenseURL_Importer,Section:vSection_Importer,URL:vURL_Importer,Library:vLibrary_Importer,Dependencies:vDependencies_Importer,AHK_Version:vAHK_Version_Importer,KeyWords:vKeywords_Importer}, SnippetClone,bIsEditing,ConvertingAHKRARE)
return
; ACSISubmit:
; return
fSubmitImporter(SubmissionObj, Snippet,bIsEditing,ConvertingAHKRARE:=false)
{ ;; submits inputs

    gui, ACSI: submit, nohide
    gui, 1: -Disabled
    if !ConvertingAHKRARE
    {
        if ((SubmissionObj.Snippet="")  || (SubmissionObj.Name="")   || (SubmissionObj.Library=""))
        {
            i:=0
            missingStr:=""
            for k,v in SubmissionObject
            {
                
                if (v="")
                    missingStr.= k ":" v (mod(3,++i)?",`n":", ")
            }
            MsgBox 0x40030, `% script.name " - Snippet Editor", "The contents fed to be edited do not resemble a valid snippet object.`n`nPlease check for errors in the data structure`, as well as the source code.`nFaulty Values:`n" missingStr "`nReturning to Main GUI"
            return
        }
    }

/*
    required for saving:

    SubmissionObj.Snippet
        SubmissionObj.Description
        SubmissionObj.Example
    SubmissionObj.Name
    SubmissionObj.Library

*/


    OldHash:=Snippet.Metadata.Hash
    OldLib:=Snippet.Metadata.Library
    ttip(SubmissionObj.Name,SubmissionObj.Library)
    Key:=SubmissionObj.Name . SubmissionObj.Library . SubmissionObj.Snippet ;; cuz the hash is no longer required to be translated, I can make it 
    Hash:=Object_HashmapHash(Key) ; Issue: What to include in the hashed snippet name?
    Obj:={Name:SubmissionObj.Name,Author:SubmissionObj.Author,Date:DateParse(SubmissionObj.Date),License:SubmissionObj.Licens,URL:SubmissionObj.URL,Section:SubmissionObj.Section,Version:SubmissionObj.Version,Hash:Hash} ;; decide if we actually want to     if (Code="")  ;; do not write to disc
    IniSave:=SubmissionObj.Clone()
    IniSave.Hash:=Hash
    IniSave.Remove("Code")
    IniSave.Remove("Description")
    IniSave.Remove("Example")
    IniSave.Remove("Code")
    for k,v in IniSave
    {
        if (v="") || (k="Code") || (k="Description") || (k="Example")
            IniSave.Remove(k)
        if (k="Code") 
            IniSave.Remove(k)
        if (k="Description") 
            IniSave.Remove(k)
        if (k="Example")
            IniSave.Remove(k)
        if (k="Snippet")
            IniSave.Remove(k)
    }
    Extensions:=[".ahk",".ini",".example",".description"]
    for k,v in Extensions
    {
        if FileExist(A_ScriptDir "\Sources\" OldLib "\" OldHash v)
        {
            FileCopy, % A_ScriptDir "\Sources\" OldLib "\" OldHash v,% BackupLocation:=A_ScriptDir "\Sources\000-BACKUP_" OldLib "_" OldHash v,1
            FileDelete, % A_ScriptDir "\Sources\" OldLib "\" OldHash v
        }
        if FileExist(A_ScriptDir "\Sources\" OldLib "\" snippet.Metadata.name v)
        {
            FileCopy, % A_ScriptDir "\Sources\" OldLib "\" OldHash v,% BackupLocation:=A_ScriptDir "\Sources\000-BACKUP_" OldLib "_" Snippet.metadata.name v,1
            FileDelete, % A_ScriptDir "\Sources\" OldLib "\" snippet.Metadata.Name v
        }
    }
    Success:=Expected:=0
    if (IniSave.Count()>0) && (IniSave.Count()!="")
        if ACSI_fWriteIni({Info:IniSave},A_ScriptDir "\Sources\" SubmissionObj.Library "\" Hash ".ini")
            Success++
    if (SubmissionObj.Snippet!="") && (RegExReplace(SubmissionObj.Snippet,"\s*","")!="") && !Instr(SubmissionObj.Snippet,"Error 01: No code-file was found under the expected path ")
    {
        if fWriteTextToFile(SubmissionObj.Snippet,NewFile:=A_ScriptDir "\Sources\" SubmissionObj.Library "\" Hash ".ahk")
            Success++
    }
    if (SubmissionObj.Example!="") && (RegExReplace(SubmissionObj.Example,"\s*","")!="") && !Instr(SubmissionObj.Example, "Error 01: No example-file was found under the expected path")
    {
        if fWriteTextToFile(SubmissionObj.Example,A_ScriptDir "\Sources\" SubmissionObj.Library "\" Hash ".example")
            Success++
    }
    if (SubmissionObj.Description!="") && (RegExReplace(SubmissionObj.Description,"\s*","")!="") && !Instr(SubmissionObj.Description, "Error 01: No example-file was found under the expected path")
    {
        if fWriteTextToFile(SubmissionObj.Description,A_ScriptDir "\Sources\" SubmissionObj.Library "\" Hash ".description")
            Success++

    }
    if (SubmissionObj.Count()>0) && (SubmissionObj.Count()!="")
        Expected++
    if (SubmissionObj.Snippet!="") && (RegExReplace(SubmissionObj.Snippet,"\s*","")!="") && !Instr(SubmissionObj.Snippet,"Error 01: No code-file was found under the expected path ")
        Expected++
    if (SubmissionObj.Example!="") && (RegExReplace(SubmissionObj.Example,"\s*","")!="") && !Instr(SubmissionObj.Example, "Error 01: No example-file was found under the expected path")
        Expected++
    if (SubmissionObj.Description!="") && (RegExReplace(SubmissionObj.Description,"\s*","")!="") && !Instr(SubmissionObj.Description, "Error 01: No example-file was found under the expected path")
        Expected++
    if (Expected>Success)
    {
        SplitPath, BackupLocation,,,,OutFileName
        MsgBox 0x30, % script.name " - Snippet Editor", "Error:`n" Expected " files were expected to be updated`, but only " Success " files could be written to file.`nBackup-files exist in the LibraryFolder under the name " OutFileName
    }
    if (ConvertingAHKRARE)
    {
        WinActivate, AHK-Rare_TheGui
        sleep, 400
    }
    if script.config.settings.bDebugSwitch
        MsgBox,, % script.name, % "Old Hash:" Snippet.Metadata.Hash "`nNewHash: " Hash
    fGuiHide_2()
    SplitPath,% NewFile,, Dir, ,Name
    Extensions:=[".ahk",".ini",".example",".description"]
    Restore:=0
    for k,v in Extensions
    {
        if FileExist(NewFile) && FileExist(Dir "\000-BACKUP_" Snippet.Metadata.Hash v)
        {
            FileDelete,% Dir "\000-BACKUP_" Snippet.Metadata.Hash v
            ; FileDelete, FilePattern
        }
        else if !FileExist(NewFile) && FileExist(Dir "\000-BACKUP_" Snippet.Metadata.Hash v)
        {
            ; FileCopy, Source, Dest [, Flag (1 = overwrite)]
            FileCopy, % Dir "\000-BACKUP_" Snippet.Metadata.Hash v, % Dir "\" Snippet.Metadata.Hash v
            Restore++
            ; DONE: add path for when new files do not exist - restore from backup, notify user of error
        }
        if Restore
            MsgBox 0x30, % script.name " - Snippet Editor", "Error:`nOnly "  Restore " Files could be restored from the error, " k-Restore " files must be`nmanually recovered from the backup."
        
    }
    reload
    return
}
fWriteTextToFile(Text,Path)
{ ;; writes string to file, replacing the current file
    FileRecycle, % Path      ;; is this smarter than wiping file contents via .fileopen(,w) → .fileclose() ??
    FileAppend, % Text, % Path
    return (FileExist(Path)?1:0)
}
ACSI_fWriteIni(ByRef Array2D, INI_File)  ; write 2D-array to INI-file
{
    SplitPath, INI_File, INI_File_File, INI_File_Dir, INI_File_Ext, INI_File_NNE, INI_File_Drive
		if (d_ACSI_fWriteIni_st_count(INI_File,".ini")>0)
		{
			INI_File:=d_ACSI_fWriteIni_st_removeDuplicates(INI_File,".ini") ;. ".ini" ; reduce number of ".ini"-patterns to 1
			if (d_ACSI_fWriteIni_st_count(INI_File,".ini")>0)
				INI_File:=SubStr(INI_File,1,StrLen(INI_File)-4) ; and remove the last instance
		}
	if !FileExist(INI_File_Dir) ; check for ini-files directory
	{
		MsgBox, Creating "INI-Files"-directory at Location`n"%A_ScriptDir%", containing an ini-file named "%INI_File%.ini"
		FileCreateDir, % INI_File_Dir
	}
	OrigWorkDir:=A_WorkingDir
	SetWorkingDir, % INI_File_Dir
	for SectionName, Entry in Array2D 
	{
		Pairs := ""
		for Key, Value in Entry
        {
            ; if (Instr(Key,"Desc") || InStr(Key,"Ex"))
            ;     Value:=Quote(Value)
			Pairs .= Key "=" Value "`n"
        }
		IniWrite, %Pairs%, % Instr(INI_File,".ini")?INI_File:INI_File . ".ini", %SectionName%
	}
	if A_WorkingDir!=OrigWorkDir
		SetWorkingDir, %OrigWorkDir%
    return FileExist(Instr(INI_File,".ini")?INI_File:INI_File . ".ini")?true:false
	/* Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
		
	;-------------------------------------------------------------------------------
		WriteINI(ByRef Array2D, INI_File) { ; write 2D-array to INI-file
	;-------------------------------------------------------------------------------
			for SectionName, Entry in Array2D {
				Pairs := ""
				for Key, Value in Entry
					Pairs .= Key "=" Value "`n"
				IniWrite, %Pairs%, %INI_File%, %SectionName%
			}
		}
	*/
}
d_ACSI_fWriteIni_st_removeDuplicates(string, delim="`n")
{ ; remove all but the first instance of 'delim' in 'string'
	; from StringThings-library by tidbit, Version 2.6 (Fri May 30, 2014)
	/*
		RemoveDuplicates
		Remove any and all consecutive lines. A "line" can be determined by
		the delimiter parameter. Not necessarily just a `r or `n. But perhaps
		you want a | as your "line".

		string = The text or symbols you want to search for and remove.
		delim  = The string which defines a "line".

		example: st_removeDuplicates("aaa|bbb|||ccc||ddd", "|")
		output:  aaa|bbb|ccc|ddd
	*/
	delim:=RegExReplace(delim, "([\\.*?+\[\{|\()^$])", "\$1")
	Return RegExReplace(string, "(" delim ")+", "$1")
}
d_ACSI_fWriteIni_st_count(string, searchFor="`n")
{ ; count number of occurences of 'searchFor' in 'string'
	; copy of the normal function to avoid conflicts.
	; from StringThings-library by tidbit, Version 2.6 (Fri May 30, 2014)
	/*
		Count
		Counts the number of times a tolken exists in the specified string.

		string    = The string which contains the content you want to count.
		searchFor = What you want to search for and count.

		note: If you're counting lines, you may need to add 1 to the results.

		example: st_count("aaa`nbbb`nccc`nddd", "`n")+1 ; add one to count the last line
		output:  4
	*/
	StringReplace, string, string, %searchFor%, %searchFor%, UseErrorLevel
	return ErrorLevel
}

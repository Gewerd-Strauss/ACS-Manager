#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
; loop, A_ScriptDir
    Importer(Clipboard)
return
Numpad1::f_GuiShow_1(vGUIWidth,vGUIHeight)

/*
TODO: change  the functions fWriteIni to convert "Desc"- and "Ex"-key'd values to quoteds
TODO: make this GUI screen-relative in width
*/


Importer(Text)
{

    global ;; what is the point of wrapping a GUI into a 
    static Snippet
    static Desc
    static Ex
            ; Ahk Code Snippet Importer
            gui, ACSI: destroy
            gui, ACSI: new, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border +labelACSI -Resize ;+MinSize1000x		
            gui, ACSI: default
            gui, +hwndACSIGUI
            if vsdb || (A_DebuggerName="Visual Studio Code")
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
            , vLastCreationScreenHeight:=vGuiHeight  
            , vLastCreationScreenWidth:=vGuiWidth
            gui, font, s9 cRed, Segoe UI
            SysGet, Mon,MonitorWorkArea 
            Height:=MonBottom
            if (!vGUIWidth and !vGuiHeight) || (((vGUIWidth!=(A_ScreenWidth-20)) || (vGuiHeight!=(A_ScreenHeight))) && !bSwitchSize) ; assign outer gui dimensions either if they don't exist or if the resolution of the active screen has changed - f.e. when undocking or docking to a higher resolution display. The lGuiCreate_1-subroutine is also invoked in total if the resolution changes, but this is the necessary inner check to reassign dimensions.
            { 
                vGUIWidth:=A_ScreenWidth*1.0 - 20  ;-910 ; 0.6@1440 starts clipping
                vGUIWidth:=1920-20
                , vGUIHeight:=MonBottom*1.0 - 20 
                vGUIHeight:=MonBottom-5
            }
            EditWidth:=vGUIWidth-2*15
            , EditHeight:=(vGUIHeight>1100)?vGUIHeight*0.25+30 : vGUIHeight*0.225+30
            , SmallFieldsStart:=EditHeight*3+25
            , SmallFieldsHeight:=(vGUIHeight-EditHeight*3)/9
            , LicenseFieldsHeight:=(vGUIHeight-EditHeight*3+20)/9
            gui, add, edit, w%EditWidth% h%EditHeight% vvSnippet,% "[[Insert Snippet]]"
            gui, add, edit, w%EditWidth% h%EditHeight% vvDesc, % "[[Insert Description]]"
            gui, add, edit, w%EditWidth% h%EditHeight% vvEx, % "[[Insert Example]]"
            gui, add, text, y%SmallFieldsStart% xp, Name
            gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvName, % "F1"
            gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Author
            gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvAuthor, % "Gewerd"
            gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, version
            gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvVersion, % "1.1.1"
            gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Date
            gui, add, edit, yp disabled xp+100 w120 h%SmallFieldsHeight% vvDate, % A_YYYY A_MM A_DD
            gui, add, text, yp+24 xp-100, License
            gui, add, ComboBox, yp xp+100 w120 r5 h%SmallFieldsHeight% vvLicense, % "MIT|BSD3|Unlicense|WTFPL||none|paste"
            gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Section
            gui, add, ComboBox, yp xp+100 w120 r5 h%SmallFieldsHeight% vvSection, % "Clipboard||Command CommandLine|Date or Time|Varius get|graphic|gui - customise|gui - to change|gui - control type|gui - get informations|gui - interacting|gui - menu|gui - icon|FileSystem|Font things|Hooks/Messaging|Internet/Network|Math/Converting|Objects|String/Array/Text|Keys/Hotkeys/Hotstrings|Tooltips|System functions/Binary Handling|System/User/Hardware|UIAutomation|ACC (MSAA)|Internet Explorer/Chrome/FireFox/HTML|Variables|Other languages/MCode|Other|"
            gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, URL
            gui, add, edit, yp xp+100 w120 h%SmallFieldsHeight% vvURL, % "www.google.com"
            gui, add, text, yp+%SmallFieldsHeight%+5 xp-100, Library
            ; gui, add, text, y%SmallFieldsStart% xp, Name
            ; gui, add, edit, yp xp+100 w120 h20 vvName, % "F1"
            ; gui, add, text, yp+23 xp-100, Author
            ; gui, add, edit, yp xp+100 w120 h20 vvAuthor, % "Gewerd"
            ; gui, add, text, yp+23 xp-100, version
            ; gui, add, edit, yp xp+100 w120 h20 vvVersion, % "1.1.1"
            ; gui, add, text, yp+23 xp-100, Date
            ; gui, add, edit, yp disabled xp+100 w120 h20 vvDate, % A_YYYY A_MM A_DD
            ; gui, add, text, yp+23 xp-100, License
            ; gui, add, ComboBox, yp xp+100 w120 r5 h20 vvLicense, % "MIT|BSD3|Unlicense|WTFPL||none|paste"
            ; gui, add, text, yp+23 xp-100, Section
            ; gui, add, ComboBox, yp xp+100 w120 r5 h20 vvSection, % "Clipboard||Command CommandLine|Date or Time|Varius get|graphic|gui - customise|gui - to change|gui - control type|gui - get informations|gui - interacting|gui - menu|gui - icon|FileSystem|Font things|Hooks/Messaging|Internet/Network|Math/Converting|Objects|String/Array/Text|Keys/Hotkeys/Hotstrings|Tooltips|System functions/Binary Handling|System/User/Hardware|UIAutomation|ACC (MSAA)|Internet Explorer/Chrome/FireFox/HTML|Variables|Other languages/MCode|Other|"
            ; gui, add, text, yp+25 xp-100, URL
            ; gui, add, edit, yp xp+100 w120 h20 vvURL, % "www.google.com"
            ; gui, add, text, yp+25 xp-100, Library
            Ind:=0
            loop, files, % A_ScriptDir "\Sources\*.*", D
            {
                Ind++
                ;; todo: make this load from a path in script.settings.path, including scriptObj
                SplitPath,% A_LoopFileFullPath,OutName, OutDir
                OutName:=strsplit(OutName,"\")[strsplit(OutName,"\").MaxIndex()]
                str.=OutName "|" 
                if (Ind=1)
                    str.="|"
            }
            gui, add, ComboBox, yp xp+100 w120 h%SmallFieldsHeight% R100 vvLibrary,% str
        EditWidth2:=EditWidth-220-110
            gui, add, text, yp-195 xp+150, License
            gui, add, button, yp+20 xp h%SmallFieldsHeight% gfSubmit, Ingest
            gui, add, edit, y%SmallFieldsStart% xp+80 w%EditWidth2% h%LicenseFieldsHeight% r12  vvLicenseInsert, % "[[Insert License]]"

                                    ; gui, add, text, yp+20 xp, Author vSnippet
                                    ; gui, add, edit, yp xp+35 w30 h15 vAuthor
                                    ; gui, add, text, yp+40 xp, Author
                                    ; gui, add, edit, yp+20 xp+35 w30 h15 Date
                                    ; gui, add, edit, yp+20 xp+70 w30 h15 vLicense
                                    ; gui, add, edit, yp+20 xp+105 w30 h15 vURL
                                    ; gui, add, edit, yp+20 xp+140 w30 h15 vVersion
                                    ; gui, add, edit, yp+20 xp+175 w30 h15 v
            gui, font, s9 cWhite, Segoe UI
            f_GuiShow_1(vGUIWidth,vGUIHeight)
            Hotkey, IfWinActive, % "ahk_id " ACSIGUI
            Hotkey, Esc, f_GuiHide_1
            ; Hotkey, ^Tab,lTabThroughTabControl
            ; Hotkey, ^f, lFocusSearchBar
            ; Hotkey, ^s, lFocusSearchBar
            ; Hotkey, ^k, lFocusListView
            ; Hotkey, ^r, lGuiCreate_2
            ; Hotkey, if, % SearchIsFocused
            ; HotKey, ^BS, lDeleteWordFromSearchBar
            ; Hotkey, ^k, lFocusListView
            ; Hotkey, ~Enter, lSearchSnippetsEnter
            ; Hotkey, Del, lClearSearchbar

            ; Hotkey, if, % ListViewIsFocused
            ; Hotkey, ~Up, ListViewUp
            ; Hotkey, ~Down, ListViewDown
            ; Hotkey, ~LButton, ListViewSelect

            
            ; hotkey, if, % RCFieldIsClicked
            ; Hotkey, ~RButton, lCopyScript
            ; Hotkey, ~LButton, lCopyScript
            hotkey, if
            ; hotkey, if, % EditFieldIsClicked
            ; Hotkey, ~RButton, lCopyScript
            ; Hotkey, ~LButton, lCopyScript
            ; Gui, Color, 4f1f21, 432a2e
            ; gosub, lFocusListView
            ; sleep, 300
            LastScaledSize:=[vGUIWidth,vGUIHeight]
    return
}
f_GuiHide_1()
{
    gui, ACSI: hide
    return
}

f_GuiShow_1(Width,Height)
{
    gui, ACSI: show, w%Width% h%Height%, % GuiNameMain
    return
}
fSubmit()
{ ;; submits inputs
    global ;; how do I make this function not must-be-global??
    gui, ACSI: submit, nohide
    ttip(vName,vLibra)
    Key:=vName  vLibrary
    , Hash:=Object_HashmapHash(Key) ; Issue: What to include in the hashed snippet name?
    , Obj:={Name:vName,Author:vAuthor,Date:vDate,License:vLicense,URL:vURL,Section:vSection,Version:vVersion,Hash:Hash} ;; decide if we actually want to     if (Code="")  ;; do not write to disc
    if (vLibrary="")
    {
        MsgBox, % "TODO: throw error1"
        ; return
    }
    if !(Obj.Count()>0) ;; do not write to disc if no metadata has been found
    {
        MsgBox, % "TODO: throw error2"
        return
    }
    ; if (Hash=351425664)
    ;     return
    Code:=fWriteTextToFile(vSnippet,A_ScriptDir "\Sources\" vLibrary "\" Hash ".ahk")
    Metadata:=fWriteIni({Info:Obj},A_ScriptDir "\Sources\" vLibrary "\" Hash ".ini")
    if (vEx!="")
        success_Example:=fWriteTextToFile(vEx,A_ScriptDir "\Sources\" vLibrary "\" Hash ".example")
    if (vDesc!="")
        success_Description:=fWriteTextToFile(vDesc,A_ScriptDir "\Sources\" vLibrary "\" Hash ".description")
    return
}
Object_HashmapHash(Key)
{		;; thank you to u/anonymous1184 for writing this for me for an old project, certainly helped a lot here.
	if !StrLen(Key)
		throw Exception("No key provided", -2)
	if IsObject(Key)
		return key
	if Key is integer
		Key:=Format("{:d}", Key)
	else if Key is float
		Key:=Format("{:f}", Key)
	return DllCall("Ntdll\RtlComputeCrc32"
		, "Ptr",0
		, "WStr",Key
		, "Int",StrLen(Key) * 2
		, "UInt")
}
fWriteTextToFile(Text,Path)
{ ;; writes string to file, replacing the current file
    FileDelete, % Path      ;; is this smarter than wiping file contents via .fileopen(,w) → .fileclose() ??
    FileAppend, % Text, % Path
    return FileExist(Path)?1:0
}

fWriteINI(ByRef Array2D, INI_File)  ; write 2D-array to INI-file
{
    SplitPath, INI_File, INI_File_File, INI_File_Dir, INI_File_Ext, INI_File_NNE, INI_File_Drive
		if (d_fWriteINI_st_count(INI_File,".ini")>0)
		{
			INI_File:=d_fWriteINI_st_removeDuplicates(INI_File,".ini") ;. ".ini" ; reduce number of ".ini"-patterns to 1
			if (d_fWriteINI_st_count(INI_File,".ini")>0)
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
    return
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
d_fWriteINI_st_removeDuplicates(string, delim="`n")
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
d_fWriteINI_st_count(string, searchFor="`n")
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
Quote(String)
{ ; u/anonymous1184 | fetched from https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
    return """" String """"
}
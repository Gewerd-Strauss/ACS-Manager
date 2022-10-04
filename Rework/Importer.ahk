#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
; loop, A_ScriptDir
    Importer(Clipboard)
return
Numpad1::f_GuiShow_1(vGUIWidth,vGUIHeight)

/*
TODO: change  the functions fWriteIni to convert "Desc"- and "Ex"-key'd values to quoteds
*/


Importer(Text)
{

    global ;; what is the point of wrapping a GUI into a 
    static Snippet
    static Desc
    static Ex

            gui, ACSI: destroy
            gui, ACSI: new, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border +labelgResizing -Resize ;+MinSize1000x		
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
            if (!vGUIWidth and !vGuiHeight) || (((vGUIWidth!=(A_ScreenWidth-20)) || (vGuiHeight!=(A_ScreenHeight))) && !bSwitchSize) ; assign outer gui dimensions either if they don't exist or if the resolution of the active screen has changed - f.e. when undocking or docking to a higher resolution display. The lGuiCreate_1-subroutine is also invoked in total if the resolution changes, but this is the necessary inner check to reassign dimensions.
            { 
                vGUIWidth:=A_ScreenWidth*1.0 - 20  ;-910 ; 0.6@1440 starts clipping
                , vGUIHeight:=MonBottom*1.0 - 20 
            }
            EditWidth:=vGUIWidth-2*30
            , EditHeight:=vGUIHeight*0.25+30
            , SmallFieldsStart:=EditHeight*3+25
            gui, add, edit, w%EditWidth% h%EditHeight% vvSnippet,% "[[Insert Snippet]]"
            gui, add, edit, w%EditWidth% h%EditHeight% vvDesc, % "[[Insert Description]]"
            gui, add, edit, w%EditWidth% h%EditHeight% vvEx, % "[[Insert Example]]"
            gui, add, text, y%SmallFieldsStart% xp, Name
            gui, add, edit, yp xp+100 w120 h15 vvName, % "Object_HashmapHash"
            gui, add, text, yp+15 xp, Author
            gui, add, edit, yp xp+100 w120 h15 vvAuthor, % "Gewerd"
            gui, add, text, yp+15 xp-100, version, 
            gui, add, edit, yp xp+100 w120 h15 vvVersion, % "1.1.1"
            gui, add, text, yp+15 xp-100, Date
            gui, add, edit, yp xp+100 w120 h15 vvDate, % "30.09.2022"
            gui, add, text, yp+15 xp-100, License
            gui, add, edit, yp xp+100 w120 h15 vvLicense, % "MIT"
            gui, add, text, yp+15 xp-100, URL
            gui, add, edit, yp xp+100 w120 h15 vvURL, % "www.google.com"
            gui, add, text, yp+15 xp-100, Library
            gui, add, ComboBox, yp xp+100 w120  vvLibrary,% "Library1|A|B|C"
            gui, add, button, yp+15 xp-100 gfSubmit, Ingest


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
{
    global
    /*
    vDesc
    */
    gui, ACSI: submit, nohide
    Hash:=Object_HashmapHash(vLibrary " " vName " " ) ; Issue: What to include in the hashed snippet name?
    ; Obj:={Name:vName,Author:vAuthor,Date:vDate,Desc:vDesc,License:vLicense,URL:vURL,Library:vLibrary,Version:vVersion,Hash:Hash}
    , Obj:={Name:vName,Author:vAuthor,Date:vDate,Desc:vDesc,Ex:vEx,License:vLicense,URL:vURL,Version:vVersion,Hash:Hash} ;; decide if we actually want to 
    MsgBox, % "Figure out how to write a multiline string to obj-generated ini properly"
    Ini:=fWriteIni({Info:Obj},A_ScriptDir "\Sources\" vLibrary "\" Hash ".ini")
    , Code:=fWriteCode(vSnippet,A_ScriptDir "\Sources\" vLibrary "\" Hash ".ahk")
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
fWriteCode(Code,Path)
{ ; write code to file
    FileDelete, % Path
    FileAppend, % Code, % Path
    return
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
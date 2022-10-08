/*
TODO:::: ADD NAMESPACED VERSIONS OF FUNCTIONS FROM stringthings.ahk AND TF.AHK to this script
*/
#SingleInstance, Force
#Warn,,Off 
#persistent
SetTitleMatchMode, 2
SendMode Input

; some performance stuff
ListLines, Off
#KeyHistory, 0
SetWorkingDir, %A_ScriptDir%
CurrentMode:="Instr"
; Add scriptObj-template and convert Code to use it - maybe, just a thought. Syntax of the Library-File is probably way too special for doing so, and there are no real configs to save anyways
; separate library-files and settings-files, take a peek at ahk-rare to see what they store in settings
global CURRENTCALLINDEX:=0

/*
for creditsRaw, use "/" in the "URL"-field when the snippet is not published yet (e.g. for code you've written yourself and not published yet)
space author, SnippetNameX and URLX out by spaces or tabs, and remember to include "-" inbetween both fields
when 2+ snippets are located at the same url, concatenate them with "|" and treat them as a single one when putting together the URL's descriptor string
finally, make sure toingest 'CreditsRaw' into the 'credits'-field of the template below.
*/


#Include <ScriptObj\scriptObj>
CreditsRaw=
(LTRIM
author1   -		 snippetName1		   		  			-	URL1
Gewerd Strauss		- snippetName2|SnippetName3 (both at the same URL)								-	/
Ixiko - AHK-Rare - https://github.com/Ixiko/AHK-Rare
Paris - DateParse - https://github.com/Paris/AutoHotkey-Scripts/blob/master/DateParse.ahk
tidbit - String Things - https://www.autohotkey.com/boards/viewtopic.php?t=53
hi5 - tf - https://github.com/hi5/TF#TF_InsertPrefix
jballi - AddToolTip - https://www.autohotkey.com/boards/viewtopic.php?t=30079
)
FileGetTime, ModDate,%A_ScriptFullPath%,M
FileGetTime, CrtDate,%A_ScriptFullPath%,C
CrtDate:=SubStr(CrtDate,7,  2) "." SubStr(CrtDate,5,2) "." SubStr(CrtDate,1,4)
, ModDate:=SubStr(ModDate,7,  2) "." SubStr(ModDate,5,2) "." SubStr(ModDate,1,4)
, global script := {   base         : script
                    ,name         : regexreplace(A_ScriptName, "\.\w+")
                    ,version      : FileOpen(A_ScriptDir "\version.ini","r").Read() ;; Gets read in from settings-file later
                    ,dbgLevel	  : 1
                    ,computername : A_ComputerName
                    ,author       : "Gewerd Strauss"
					,authorID	  : "LAPTOP-C"
					,authorlink   : ""
                    ,email        : ""
                    ,credits      : CreditsRaw
					,creditslink  : ""
                    ,crtdate      : CrtDate
                    ,moddate      : ModDate
                    ,homepagetext : ""
                    ,homepagelink : ""
                    ,ghtext 	  : "GH-Repo"
                    ,ghlink       : "https://github.com/Gewerd-Strauss/AHK-Code-Snippets"
                    ,doctext	  : ""
                    ,doclink	  : ""
                    ,forumtext	  : ""
                    ,forumlink	  : ""
                    ,donateLink	  : ""
                    ,resfolder    : A_ScriptDir "\res"
                    ,iconfile	  : A_ScriptDir "\res\sct.ico"
					,rfile  	  : "https://github.com/Gewerd-Strauss/AHK-Code-Snippets/archive/refs/heads/Speed-Test.zip"
					,vfile_raw	  : "https://raw.githubusercontent.com/Gewerd-Strauss/AHK-Code-Snippets/Speed-Test/version.ini" 
					,vfile 		  : "https://raw.githubusercontent.com/Gewerd-Strauss/AHK-Code-Snippets/Speed-Test/version.ini" 
					,vfile_local  : A_ScriptDir "\version.ini" 
                    ,ErrorCache	  :	[]
                    ,config		  :	[]
					,configfile   : A_ScriptDir "\INI-Files\" regexreplace(A_ScriptName, "\.\w+") ".ini"
                    ,configfolder : A_ScriptDir "\INI-Files"}

, f_CreateTrayMenu()


, global bSearchSnippets:=false
FileDelete, % script.configfile ;; for testing purposes and keeping the settings updated when adding/changing keys
if !script.Load(,1) 
{ ;; default settings
	script.config:={Settings:{Search_Code: false ;" " ";Check if you want to search code of snippets as well. Adds substantial overhead at bootup."
	, Search_Description:false
	, Search_Examples:false
	, Search_InString_MetaFields:true
	, DateFormat:"dd.MM.yyyy"
	, CopyDescriptionToOutput:true
	, CopyExampleToOutput:true
	, LibraryRelativeSI:false
	, ShowRedraw:false
	, bDebugSwitch:false
	, Max_InDepth_Searchable:200}
   ,Search_Descriptions:{Search_Code:";Check if you want to search code of snippets as well. Adds substantial overhead at bootup."
    , Search_Description:";Check if you want to search descriptions of snippets as well. Adds substantial overhead at bootup."
	, Search_Examples:";Check if you want to search examples of snippets as well. Adds substantial overhead at bootup."
	, Search_InString_MetaFields:";Check if you want to search via In-String-matching in Metadata, instead of only allowing exact matches"
	, DateFormat:";Set the format with which to display dates."
	, CopyDescriptionToOutput:";Decide if you want to include the documentation when copying a snippet"
	, CopyExampleToOutput:";Decide if you want to include the example when copying a snippet"
	, LibraryRelativeSI:";Set SnippetIdentifier relative to its own library"
	, ShowRedraw:"Display the redrawing of the LV-Control. Can reduce performance."
	, bDebugSwitch:"Set to true to expose additional information helpful for debugging issues."
	, Max_InDepth_Searchable:";Set the maximum number of snippets for which the script will also search all previously loaded Codes, Descriptions and Examples.`nFor more snippets, these searches will not be performed to not reduce performance too much."}}
	script.Save()
}
; script.Version:=script.config.Settings.ScriptVersion
SnippetsStructure:=fLoadFolderLibraries()
oArr:=SnippetsStructure.Clone()


GUI_Mode:=1
bSwitchSize:=0
GuiNameMain:="TotallyNotAHKRAre"
GuiNameIngestion:="Ingestion Helper"
RESettings2 :=
( LTrim Join Comments
{
	"TabSize": 4,
	"Indent": "`t",
	"FGColor": 0xEDEDCD,
	"BGColor": 0x3F3F3F,
	"Font": {"Typeface": "Consolas", "Size": 11},
	"WordWrap": False,
	
	"UseHighlighter": True,
	"HighlightDelay": 200,
	"Colors": {
		"Comments":     0x7F9F7F,
		"Functions":    0x7CC8CF,
		"Keywords":     0xE4EDED,
		"Multiline":    0x7F9F7F,
		"Numbers":      0xF79B57,
		"Punctuation":  0x97C0EB,
		"Strings":      0xCC9893,
		
		; AHK
		"A_Builtins":   0xF79B57,
		"Commands":     0xCDBFA3,
		"Directives":   0x7CC8CF,
		"Flow":         0xE4EDED,
		"KeyNames":     0xCB8DD9,
		
		; CSS
		"ColorCodes":   0x7CC8CF,
		"Properties":   0xCDBFA3,
		"Selectors":    0xE4EDED,
		
		; HTML
		"Attributes":   0x7CC8CF,
		"Entities":     0xF79B57,
		"Tags":         0xCDBFA3,
		
		; JS
		"Builtins":     0xE4EDED,
		"Constants":    0xF79B57,
		"Declarations": 0xCDBFA3
	}
}
)
gosub, lGUICreate_1New


;;  an armada of different search testing strings :)
Clipboard:="Au:Gew Se:menu Li:Un"
Clipboard:="Au:Gew Se:menu Li:Un Da:07.10.2022"
Clipboard:="Fi:Libr AU:ano"
Clipboard:="Au:Gew Se:menu Ver:1.3"
; Clipboard:="Au:Gew Se:menu"
Clipboard:="fi:Sec"
Clipboard:="au:gew fi:ary1"
Clipboard:="Na:1 fi:ary1"
clipboard:="Na:1 fi:ary1 au:ano"
clipboard:="fi:sec au:ano"

; Clipboard:="Au:anon na:1"

return



lGUICreate_1New: ;; Fully Parametric-form
		gui, 1: destroy
		gui, 1: new, +AlwaysOnTop -SysMenu -ToolWindow -caption +Border +labelALG -Resize ;+MinSize1000x		
		gui, 1: default
		gui, +hwndMainGUI
		if vsdb || (A_DebuggerName="Visual Studio Code")
			gui, 1: -AlwaysOnTop
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
		gui, font, s9 cWhite, Segoe UI
		SysGet, Mon,MonitorWorkArea 
		if (!vGUIWidth and !vGuiHeight) || (((vGUIWidth!=(A_ScreenWidth-20)) || (vGuiHeight!=(A_ScreenHeight))) && !bSwitchSize) ; assign outer gui dimensions either if they don't exist or if the resolution of the active screen has changed - f.e. when undocking or docking to a higher resolution display. The lGuiCreate_1-subroutine is also invoked in total if the resolution changes, but this is the necessary inner check to reassign dimensions.
		{ 
			vGUIWidth:=A_ScreenWidth*1.0 - 20  ;-910 ; 0.6@1440 starts clipping
			, vGUIHeight:=MonBottom*1.0 - 20 
		}
		
		gui, font, s7 cRed, Segoe UI
		{
					; checked values will be indented unto this level
		; values which still seem a bit fishy or which I suspect to be at fault for some weird shit are indented to this line
			; Define Parameters - Margins
				WidthMargin_Global:=vGuiWidth*0.01
				, HeightMargin_Global:=vGuiHeight*0.01

			; Define Parameters - SearchBox:										
				;; ratio's checked on 100%-model
		, xPos_Search_GroupBox:=vGuiWidth*0.47 
		, yPos_Search_GroupBox:=vGuiHeight*0.01
		, Height_Search_GroupBox:=vGuiHeight*0.08
					, Width_Search_GroupBox:=vGuiWidth-(xPos_Search_GroupBox+WidthMargin_Global)
					gui, add, groupbox, x%xPos_Search_GroupBox% y%yPos_Search_GroupBox% w%Width_Search_GroupBox% h%Height_Search_GroupBox%
				
			; Define Parameters - Text XX Snippets
					xPos_Text_XXSnippetsLoaded:=xPos_Search_GroupBox											+WidthMargin_Global
					, yPos_Text_XXSnippetsLoaded:=yPos_Search_GroupBox											+(HeightMargin_Global/2)+2 ; add 2 to prevent clipping the groupbox control at the top
		, Width_Text_XXSnippetsLoaded:=Width_Search_GroupBox*0.3
		, Height_Text_XXSnippetsLoaded:=Height_Search_GroupBox*0.3
					gui, font, s11 cRed, Segoe UI
        			gui, add, text,x%xPos_Text_XXSnippetsLoaded%  y%yPos_Text_XXSnippetsLoaded% vvSearchFunctions, _____________________________________________

			; Define Parameters - DDL Searchmode
					xPos_DDL_SearchMode:=xPos_Text_XXSnippetsLoaded
					, yPos_DDL_SearchMode:=yPos_Text_XXSnippetsLoaded+Height_Text_XXSnippetsLoaded				+(HeightMargin_Global/2)
					, Width_DDL_SearchMode:=100 ;; note: this seems extensively too large
					, Height_DDL_SearchMode:=Height_Search_GroupBox-yPos_DDL_SearchMode							-(HeightMargin_Global/2)
					, Height_DDL_SearchMode2:=Height_Search_GroupBox-yPos_DDL_SearchMode							-(HeightMargin_Global/2) - 10
					xPos_DDL_SearchMode2:=xPos_Text_XXSnippetsLoaded+Width_DDL_SearchMode+WidthMargin_Global
					gui, font, s8
        			; gui, add, DDL,vSearchMethod x%xPos_DDL_SearchMode% y%yPos_DDL_SearchMode% h%Height_DDL_SearchMode% w%Width_DDL_SearchMode% r2 vCurrentMode glSetSearchMethod HwndCurrentModeHWND, InStr||RegEx	
					gui, add, button, x%xPos_DDL_SearchMode% y%yPos_DDL_SearchMode% h%Height_DDL_SearchMode2%  w%Width_DDL_SearchMode% vvExtraButton glIngestSnippet HwndExtraButtonHWND,%  "&Ingest Snippet"
					gui, add, button, x%xPos_DDL_SearchMode2% y%yPos_DDL_SearchMode% h%Height_DDL_SearchMode2%  w%Width_DDL_SearchMode% vvExtraButton2 glEditSnippet HwndExtraButton2HWND,%  "&Edit Snippet"
					gui, font, s11 cWhite, Segoe 
					Map2:={AU:"Author" ;; For fetching data from 'Matches', the presorted object
					,DA:"Date"
					,Fi:"Library"
					,Li:"License"
					,Na:"Name"
					,Se:"Section"
					,Url:"URL"
					,Ver:"Version"}
					str:=Obj2Str(Map2)
					AddToolTip(ExtraButtonHWND,"Press Enter to Search.`n" str)
			; Define Parameters: Fuzzy-Search Checkbox
					xPos_FuzzySearchCheckbox:=xPos_DDL_SearchMode + Width_DDL_SearchMode  +(WidthMargin_Global/2)
					, yPos_FuzzySearchCheckbox:=yPos_DDL_SearchMode+5
					, Width_FuzzySearchCheckbox:=144
					gui, font, s11 cBlack, Segoe 
					; gui, add, Text, x%xPos_FuzzySearchCheckbox%y%yPos_FuzzySearchCheckbox% w%Width_FuzzySearchCheckbox% gSearchParametersExplanation vbUseFuzzySearch HWNDFuzzySearchHWND,?
					
					; Gui, Add, Text, x3 w55 h30 HwndMyText gMyText,  RAM:  %myString% `%
					; Gui,+LastFound
					; Gui,Show, X%DefaultX% Y%DefaultY% h16 w60 Noactivate,RAMOverview
					; AddToolTip(MyText,"RAM free: " d:=substr(oMemState[10,"GB_AvailPhys"],1,5) "GB`nRAM used:" substr(oMemState[10,"GB_TotalPhys"]-oMemState[10,"GB_AvailPhys"],1,5) "GB")
					AddToolTip(SearchParametersExplanation,"DEPRECATED:Not active in Regex-Searchmode")
			; Define Parameters: Edit Searchmode
					xPos_Edit_SearchMode:=xPos_DDL_SearchMode+Width_DDL_SearchMode*3+WidthMargin_Global
					, yPos_Edit_SearchMode:=yPos_DDL_SearchMode
					, Width_Edit_SearchMode:=Width_Search_GroupBox-Width_DDL_SearchMode*3-3*WidthMargin_Global
					, Height_Edit_SearchMode:=Height_DDL_SearchMode
        			; gui, add, edit, x%xPos_Edit_SearchMode% y%yPos_Edit_SearchMode% w%Width_Edit_SearchMode% r1 cBlack glCheckStringForLVRestore vSearchString HwndSearchStringHWND,  ; Search here
        			gui, add, edit, x%xPos_Edit_SearchMode% y%yPos_Edit_SearchMode% w%Width_Edit_SearchMode% r1 cBlack  vSearchString HwndSearchStringHWND,  ; Search here
					AddToolTip(SearchStringHWND,"Enter search string. Use key 'ID:xx' to search by function ID, and key 's:xx' to search by section index")
			; Define Parameters - ListView
					xPos_ListView:=WidthMargin_Global
		, yFraction_ListView:=0.1
		, HeightFraction_ListView:=0.40
					, yPos_ListView:=vGuiHeight*yFraction_ListView
					, Width_ListView:=vGuiWidth-2*WidthMargin_Global
					, Height_ListView:=vGuiHeight*HeightFraction_ListView
        			gui, font,s8
					 gui, add, Listview, x%xPos_ListView% y%yPos_ListView% w%Width_ListView% h%Height_ListView% +Report ReadOnly Count%MaxSnippetCount% -vScroll vLVvalue gfLV_Callback, Section|Snippet Name|Hash|Library|Snippet Identifier|Ingestion-Order|License|Version|Author|Snippet Identifier
					guicontrol, font, LVvalue
			; Define Parameters - Description Box
					xPos_DescriptionBox:=WidthMargin_Global
		, yPos_DescriptionBox:=(yPos_ListView+Height_ListView+(HeightMargin_Global))			;;vGuiHeight*HeightFraction_UpToDescriptionBox:=(HeightFraction_ListView+yFraction_ListView+(HeightMargin_Global/100))		;; yPos_ListView+HeightListView+1*Margin
		, Width_DescriptionBox:=vGuiWidth*(0.135+0.02+0.005)
		, Height_DescriptionBox:= vGuiHeight*((vGuiHeight-(yPos_DescriptionBox+2*HeightMargin_Global))/vGuiHeight)  ;vGuiHeight*d:=(1-(HeightFraction_UpToDescriptionBox+(HeightMargin_Global/100)))
													; yPos_DescriptionBox:=vGuiHeight*(0.71)
													; Width_DescriptionBox:=vGuiWidth*(0.135+0.02+0.005)
													; Height_DescriptionBox:=vGuiHeight*0.275
					gui, font, s12, Segoe UI
					gui, add, edit, y%yPos_DescriptionBox% x%xPos_DescriptionBox% w%Width_DescriptionBox% h%Height_DescriptionBox% vvEdit1 disabled, Edit1
			; Define Parameters - Tab3

					xPos_Tab3:=xPos_DescriptionBox+Width_DescriptionBox+(WidthMargin_Global/1)
					, yPos_Tab3:=yPos_DescriptionBox
					, Width_Tab3:=((vGuiWidth-(Width_DescriptionBox+3*WidthMargin_Global)))
					, Height_Tab3:=Height_DescriptionBox
					; FractionTab3:=(100-((xPos_Tab3-2*WidthMargin_Global))
					gui, font,
					gui, add, tab,y%yPos_Tab3% x%xPos_Tab3% w%Width_Tab3%  h%Height_Tab3%, CODE||Examples|Description
			; Define Parameters - Richfields
			{		;; Definition set 1
		xPos_RichCode:=xPos_Tab3+WidthMargin_Global*2
				, yPos_RichCode:=yPos_Tab3+HeightMargin_Global*2 + 2
				, Width_RichCode:=Width_Tab3-2*WidthMargin_Global - 2
				, Height_RichCode:=Height_Tab3-2*HeightMargin_Global - 4
			; RichField1
				gui, tab, CODE
				global RC:=new RichCode(RESettings2, "y" yPos_RichCode " x" xPos_RichCode  " w" Width_RichCode " h" Height_RichCode,"MainGui", HighlightBound=Func("HighlightAHK"))
				AddToolTip(RC,"Test")
			}
        	RC.HighlightBound:=Func("HighlightAHK")
			fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
			fPrePopulateLV(SnippetsStructure)

		}
		gui, tab, Examples
		global RC2:=new RichCode(RESettings2, "y" yPos_RichCode " x" xPos_RichCode  " w" Width_RichCode " h" Height_RichCode,"MainGui", HighlightBound=Func("HighlightAHK"))
        RC2.HighlightBound:=Func("HighlightAHK")
        
		gui, tab, Description
		global RC3:=new RichCode(RESettings2, "y" yPos_RichCode " x" xPos_RichCode  " w" Width_RichCode " h" Height_RichCode,"MainGui", HighlightBound=Func("HighlightAHK"))
        RC3.HighlightBound:=Func("HighlightAHK")
        
        , SearchIsFocused:=Func("ControlIsFocused").Bind("Edit1")
        , ListViewIsFocused:=Func("ControlIsFocused").Bind("SysListView321")
        , RCFieldIsClicked:=Func("ControlIsFocused").Bind("RICHEDIT50W1")
        ; , EditFieldIsClicked:=Func("ControlIsFocused").Bind("Edit3")
		gui, tab

		gui, add, statusbar, -Theme vStatusBarMainWindow  gfCallBack_StatusBarMainWindow ; finish up statusbar - settings, updating library/adding additional libraries

		SB_SetParts(370,270,71)
		; f_SB_Set()
		SB_SetText("No Code from " script.name " on clipboard.", 1)
		if (SnippetsStructure[4,"ahk"]!=SnippetsStructure[4,"ini"]) 
			script.Error:="Critical Error: Metadata for " SnippetsStructure[4,"ini"] " files has been found, but code is only present for " SnippetsStructure[4,"ahk"] " snippets."
		if (script.error!="")
			SB_SetText(script.error,4)
		else
			SB_SetText("Errors:/",4)
		SB_SetText("NE:Update Script",3)
		fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
        Hotkey, IfWinActive, % "ahk_id " MainGUI
		Hotkey, ^Tab,fTabThroughTabControl
        Hotkey, ^f, fFocusSearchBar
        Hotkey, ^s, fFocusSearchBar
        Hotkey, ^k, fFocusListView
        Hotkey, ^c, fCopyScript
		; Hotkey, ^r, lGuiCreate_2
		
			Obj_ExtraButton2:=Func("fEditSnippet").Bind(SnippetsStructure,matches)
			Hotkey, !e, % Obj_ExtraButton2
				Obj_ResetListView:=Func("fResetListView").Bind(SnippetsStructure)
				Hotkey, Del, % Obj_ResetListView

        Hotkey, if, % SearchIsFocused
        		HotKey, ^BS, fDeleteWordFromSearchBar
        		Hotkey, ^k, fFocusListView
        Hotkey, ~Enter, lSearchSnippetsEnter

        Hotkey, if, % ListViewIsFocused
		Obj_MoveOnListView2:=Func("MoveOnListView").Bind(-1)
		Obj_MoveOnListView:=Func("MoveOnListView").Bind(1)

        ; Hotkey, ~Up, % Obj_MoveOnListView2
        ; Hotkey, ~Down, % Obj_MoveOnListView
		; Obj_fLVCallback:=Func("fLV_Callback").Bind()
        Hotkey, ~Up, fLV_Callback
        Hotkey, ~Down, fLV_Callback
        
        hotkey, if, % RCFieldIsClicked
        Hotkey, ~RButton, fCopyScript
        Hotkey, ~LButton, fCopyScript
		hotkey, if
					; hotkey, if, % EditFieldIsClicked
					; Hotkey, ~RButton, fCopyScript
					; Hotkey, ~LButton, fCopyScript
					; Gui, Color, 4f1f21, 432a2e
					; fFocusListView()
					; sleep, 300
		gosub, lSelectFirstLVEntry
		LastScaledSize:=[vGUIWidth,vGUIHeight]
		gosub, lCheckClipboardContents
return
Func1(Param1)
{
	MsgBox, % Param1
	return
}


fPrePopulateLV(SnippetsStructure)
{
	if !strsplit(script.config.settings.ShowRedraw,A_Space).1
		GuiControl, -Redraw, LVvalue
	References:=fPopulateLVNew(SnippetsStructure[1],SnippetsStructure[2],SnippetsStructure[3])

	if strsplit(script.config.settings.ShowRedraw,A_Space).1
		GuiControl, +Redraw, LVvalue
	f_RescaleLV()
	if !strsplit(script.config.settings.ShowRedraw,A_Space).1
		GuiControl, +Redraw, LVvalue
	return
}
fGuiHide_1()
{
	gui, 1: hide
	return
}
fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
{
	gui, 1: show, w%vGuiWidth% h%vGuiHeight%, % GuiNameMain
	fFocusListView()
	return
}
fFocusListView()
{
	guicontrol, focus, LVvalue
	return
}
fDeleteWordFromSearchBar()
{
	SendInput, ^+{Left}{Del}{ShiftUp}{CtrlUp}
	return
}
fResetListView(SnippetObj:="")
{
	fClearSearchBar()
	fPrePopulateLV(SnippetObj)
	fSelectFirstLVEntry_Searches()
	fLV_Callback()
	return
}


fClearSearchBar()
{
	GuiControlGet, currentSearch, , SearchString
	if (currentSearch!="")
		guicontrol,,SearchString
	return
}

fTabThroughTabControl()
{
	SendInput, ^{PgDn}
	fFocusListView()
	return
}
fFocusSearchBar()
{
	guicontrol, focus, SearchString
	return
}
fCopyScript()
{
	global
	MouseGetPos,,,,mVC
	; if (mVC="RICHEDIT50W1")	; little safety to remove copying when clicking the DescriptionBox
	{
		SelectedLVEntry:=f_GetSelectedLVEntries()
		Code:=SnippetsStructure[1,SelectedLVEntry.3].Code 
		if script.config.Settings.CopyExampleToOutput
		{
			Example:=TF_InsertPrefix(SnippetsStructure[1,SelectedLVEntry.3].Example,1,, ";; ") ;; make sure the example is definitely a comment 
			Code:=PrependTextBeforeString(SnippetsStructure[1,SelectedLVEntry.3].Code,";; Example:`n" Example)
			; Clipboard:=Code:=PrependTextBeforeString(Code,";; Example:`n")
		}
		else
			Code:=SnippetsStructure[1,SelectedLVEntry.3].Code
		if script.config.Settings.CopyDescriptionToOutput
		{
			Description:=TF_InsertPrefix(SnippetsStructure[1,SelectedLVEntry.3].Description,1,, ";;; ") ;; make sure the description is definitely a comment 
			Code:=PrependTextBeforeString(Code,";;; Description:`n" Description)
		}
		else
			Code:=SnippetsStructure[1,SelectedLVEntry.3].Code
		Code:=ALG_st_Insert(";--uID:" SnippetsStructure[1,SelectedLVEntry.3].Metadata.Hash "`n",Code) . "`n" ;; prepend uID-token
		Code:=ALG_st_Insert(";--uID:" SnippetsStructure[1,SelectedLVEntry.3].Metadata.Hash "`n",Code,StrLen(Code)+StrLen(";--uID:" SnippetsStructure[1,SelectedLVEntry.3].Metadata.Hash "`n")) ;; append uID-token
		Clipboard:=Code
		nameStr:=SnippetsStructure[1,SelectedLVEntry.3,"MetaData","Name"]
		; nameStr:="abcdefghijklmno#pqrstuvwxyz1234567890"
		Str:="On Clipboard: " SubStr(nameStr,1,20) " (v." SnippetsStructure[1,SelectedLVEntry.3,"MetaData","Version"] ")"
		SB_SetText(Str , 1)
	}
	return
}
PrependTextBeforeString(Text,StringToInsert)
{ ;; adds 'StringToInsert' two lines before 'Text' and returns the result
	return StringToInsert "`n`n" Text
}

FileCount(filter, mode) {																					                                                                    	;-- count matching files in the working directory

   loop,files,% filter,% mode
     Count := A_Index
   return Count

} ;</07.01.000017>
lIngestSnippet:
gui,1: submit, NoHide
EditorImporter("Ingestion",SnippetsStructure)
return
lEditSnippet: ;; I have no idea how to bind a function to a gui-button itself.
fEditSnippet(SnippetsStructure)
return
fEditSnippet(SnippetsStructure:="",matcges:="")
{
	global
	gui,1: submit, NoHide
	ttip("Congrats, this does absolutely nothing as well")
	SelectedLVEntry:=f_GetSelectedLVEntries()
	if (Matches.Count()!="") && (Matches.Count()>0)
		EditorImporter(Matches[1,SelectedLVEntry.3] ,Matches)
	Else
		EditorImporter(SnippetsStructure[1,SelectedLVEntry.3] ,SnippetsStructure)
	return
}

fCallBack_StatusBarMainWindow()
{
; not implemented yet
	gui, submit, NoHide
	if ((A_GuiEvent="DoubleClick") && (A_EventInfo=4)) ;; trigger Error
		SB_SetText("Testing Error", 2)
	if ((A_GuiEvent="DoubleClick") && (A_EventInfo=2)) ;; print detailed Error
	{
		StatusBarGetText, currText, 2, % GuiNameMain
		if (currText!="no Error")
			if script.error
				script.Debug(script.error.Level,script.error.Label,script.error.Message,script.error.AddInfo,script.error.Vars)
			; script.Debug(2,"fCopyScript","Snippet could not be copied successfully. Clipboard might be occupied by another program.","`n------------------`nCLIPBOARD:`n`n",Clipboard,"`n-------------`nINTENDED CODE`n`n",AttemptedClipboard)
	}
	return
}
fLV_Callback()
{
	global ;; there is certainly a way to avoid this global here, but for me it is far too complicated.
	; ttip(DirectoryPath)  ; A_GuiEvent A_GuiControlEvent A_Thisfunc A_Thislabel 
	str:=fGetSearchFunctionsString()
	if (str="") ;; search-box is empty, thus we ingest the default Object
		func := Func("fLoadFillDetails").Bind(SnippetsStructure,DirectoryPath) ;; need to remember how to do this
	else 		;; search-box is not empty, thus we ingest the search results
		func := Func("fLoadFillDetails").Bind(Matches,DirectoryPath) ;; need to remember how to do this
	Settimer, % func, Off
	Settimer, % func, -150 ;; TODO: replace this timer with the hook proposed by anonymous1184
	return
}

fLoadFillDetails(SnippetsStructure,DirectoryPath)
{ ;; Load the details into the Details-Field and load Code, Example and Description
	gui,1: default
	gui,1: submit, NoHide
	if (A_GuiControlEvent="ColClick")
		return
	SelectedLVEntry:=f_GetSelectedLVEntries()
	if (SelectedLVEntry="") && (A_ThisLabel!="lSearchSnippets") ;;TODO: create an edit-GUI to modify code, example, description and metadata - essentially the Importer, but _not as fugly_
		SelectedLVEntry:=[,,1]
	Data:=SnippetsStructure[1,SelectedLVEntry[3]] ;;TODO: BUG: SelectedLVEntry[2] is not a valid key, because it maps to the element added  at that point, but not at the visually x'th 
	Path:=SubStr(DirectoryPath,1,StrLen(DirectoryPath)-1) Data["Metadata","Library"] "\" Data["MetaData","Hash"] ;SelectedLVEntry[1,1].Library "\" SelectedLVEntry[1,1].Hash
	,Code:= Data.Code ;SnippetsStructure[1,SelectedLVEntry[3]].Code
	,Description:=Data.Description ;SnippetsStructure[1,SelectedLVEntry[3]].Description
	,Example:=Data.Example ;SnippetsStructure[1,SelectedLVEntry[3]].Example

	if (bSearchSnippets)
	{
		selRow++
		SelectedLVEntry:=f_GetSelectedLVEntries(selRow)
		sel:=[]
		Data:=SnippetsStructure[1,SelectedLVEntry[3]]
		Path:=SubStr(DirectoryPath,1,StrLen(DirectoryPath)-1) Data["Metadata","Library"] "\" Data["Metadata","Hash"] ;SelectedLVEntry[1,1].Library "\" SelectedLVEntry[1,1].Hash
		,Code:=Data.Code ;SnippetsStructure[1,SelectedLVEntry[3]].Code
		,Description:=Data.Description ;SnippetsStructure[1,SelectedLVEntry[3]].Description
		,Example:=Data.Example ;SnippetsStructure[1,SelectedLVEntry[3]].Example
	}
	if (Data="")	
		return
	if (Code="") || Instr(Code,"Error 01: File '")
	{
		if FileExist(Path ".ahk")
			FileRead, Code, % Path ".ahk"
		else
		{
			if FileExist(str:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"]) ".ahk")  ;; in case the file does not exist, try with the name set within the metadata.
			{
				Path:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"])
				FileRead, Code, % Path ".ahk"
			}
			else
				Code:="Error 01: File '" Path ".ahk does not exist.`nCode could not be loaded.`nPlease Reload the script after fixing the issue."
		}
		SnippetsStructure[1,SelectedLVEntry[3]].Code:=Code
	}
	if (Description="") || Instr(Description,"Error 01: File '")
	{
		if FileExist(Path ".description")
			FileRead, Description, % Path ".description"
		else
		{
			if FileExist(strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"]) ".description")
			{
				Path:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"])
				FileRead, Description, % Path ".description"
			}
			else
				Description:="Error 01: File '" Path ".description does not exist.`nDescription could not be loaded.`nPlease Reload the script after fixing the issue."
		}
		SnippetsStructure[1,SelectedLVEntry[3]].Description:=Description
	}
	if (Example="") || Instr(Example,"Error 01: File '")
	{
		if FileExist(Path ".example")
			FileRead, Example, % Path ".example"
		else
		{
			if FileExist(strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"]) ".example")
			{
				Path:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"])
				FileRead, Code, % Path ".example"
			}
			else
				Example:="Error 01: File '" Path ".example does not exist.`nExample could not be loaded.`nPlease Reload the script after fixing the issue."
		}
		; 	Code:="Error 01: File '" Path ".example does not exist.`nCode could not be loaded.`nPlease Reload the script after fixing the issue."

		; else
		SnippetsStructure[1,SelectedLVEntry[3]].Example:=Example
	}
	if bSearchSnippets
	{
		; Name:=Data.Name
		; Version:=Data.Version
		; Author:=Data.Author
		; Library:=Data.Library
		; Section:=Data.Section
		; SectionInd:=Data.SectionInd
		; URL:=Data.URL
		; ; Date:=SubStr(Data..Date, 7, 2) "." SubStr(Data..Date, 5, 2) "." SubStr(Data..Date, 1, 4)
		; FormatTime, Date,% Data.Date, % script.config.Settings.DateFormat
		; License:=Data.License

		Name:=Data.Metadata.Name
		, Version:=Data.Metadata.Version
		, Author:=Data.Metadata.Author
		, Library:=Data.Metadata.Library
		, Section:=Data.Metadata.Section
		, SectionInd:=Data.Metadata.SectionInd
		, URL:=Data.Metadata.URL
		, License:=Data.Metadata.License
		FormatTime, Date,% Data.Metadata.Date, % script.config.Settings.DateFormat

	}
	else
	{
		Name:=Data.Metadata.Name
		, Version:=Data.Metadata.Version
		, Author:=Data.Metadata.Author
		, Library:=Data.Metadata.Library
		, Section:=Data.Metadata.Section
		, SectionInd:=Data.Metadata.SectionInd
		, URL:=Data.Metadata.URL
		, License:=Data.Metadata.License
		FormatTime, Date,% Data.Metadata.Date, % script.config.Settings.DateFormat
	}
		; missing: 
		; 						name
		; 						version
								
		; 						Author
								
		; 						library

		; 						section
		; 						sectionind
								
		; 						url
		; 						date

		; 						license
		; hash
		; lvind
	InfoText=
	(LTRIM
	Snippet: %Name% (v.%Version%)
	--------------------------------------------------------------
	Author: %Author%
	License: %License%
	Source: %URL% (%Date%)
	--------------------------------------------------------------
	Library: %Library%
	Section: %SectionInd% - %Section%
	)
	guicontrol,1:, Edit2,% InfoText
		f_FillFields(Code,Description,Example)		;; using name as the identifier could be problematic when having multiple snippets  of same name
	return
}

f_CreateTrayMenu()
{ ;; facilitates creation of the tray menu
	menu, tray, add,
	Menu, Misc, add, Open Script-folder, lOpenScriptFolder
	menu, Misc, Add, Reload, lReload
	menu, Misc, Add, About, Label_AboutFile
	SplitPath, A_ScriptName,,,, scriptname
	Menu, tray, add, Miscellaneous, :Misc
	menu, tray, add,
	return
}
lOpenScriptFolder:
run, % A_ScriptDir
return
lReload: 
reload
return
Label_AboutFile:
script.about()
return

lCheckClipboardContents:
gui, 1: Submit, NoHide
return
/*

					lCheckStringForLVRestore:  ;; will hopefully be decommissioned
					Gui, 1: Submit, NoHide
					if (SearchString!="")
						return
					gosub, lSearchSnippets
					; GuiControl, -Redraw, LVvalue
					; References:=fPopulateLVNew(SnippetsStructure[1],SnippetsStructure[2],SnippetsStructure[3])
					; if strsplit(script.config.settings.ShowRedraw,A_Space).1
					; 	GuiControl, +Redraw, LVvalue
					; f_RescaleLV()
					; if !strsplit(script.config.settings.ShowRedraw,A_Space).1
					; 	GuiControl, +Redraw, LVvalue
					return
*/

lSearchSnippetsEnter:
; A_GuiControl A_ThisHotkey A_ThisFunc A_THisLabel A_GuiControlEvent A_GuiEvent | always useful having these here when checking annoying states
lSearchSnippets:
	Settimer, % func, Off
	Gui, 1: Submit, NoHide
	Matches:=[] ;; create Obj
	; if (A_ThisLabel="lSearchSnippetsEnter")
	; {
	; 	; guicontrol, focus, SysListView321
	; 	; sleep, 1200
	; 	; SendInput, {Down Down} 
	; 	; Sleep, 100
	; 	; SendInput, {Down Up} 
	; }
	global Matches:=f_CollectMatches(SnippetsStructure[1],SearchString,References,SnippetsStructure[2]) ;; for sections, because we need to load every single snippet's metadata anyways, we might just as well preprocess into various lists?
	if (Matches!=-1)  && IsObject(Matches) ;; is this even necessary? ;; DEPRECATED: || RegExMatch(SearchString,Regex.SecSearch,s) 
	{
		global bSearchSnippets:=true ;; fuck I can't be bothered anymore
		if strsplit(script.config.settings.ShowRedraw,A_Space).1
			GuiControl, +Redraw, LVvalue
		else
			GuiControl, -Redraw, LVvalue
		fPopulateLVNew(Matches[1],SnippetsStructure[2],Matches[3])
		GuiControl, +Redraw, LVvalue
		d:= Matches[1].count() " snippets loaded from " Matches[3]  ((Matches[3]>1)?" libraries":" library")
		GuiControl,,vSearchFunctions,% Matches[1].Count() " snippets found in "  Matches[3] ((Matches[3]>1)?" libraries":" library")
		
		f_RescaleLV()
		fLoadFillDetails(Matches,DirectoryPath)
		global bSearchSnippets:=false
		fSelectFirstLVEntry_Searches()
		sleep,200
		; Matches:=[]
		SendInput, % "{Up}"
	}
return
/*

fResetSearchFunctionsString()
{ ; Snippets LibraryCount A_ThisLabel A_THisfunc
	global ;; I cannot feed SnippetsStructure to this function for unknown-to-me reasons
	GuiControlGet, ContentsSearchField,,SearchString
	; if (ContentsSearchField="")
		GuiControl,, vSearchFunctions,% "Search in " Snippets.count() " snippets from" LibraryCount " libraries."
	return	
}
*/
fGetSearchFunctionsString(Str:="")
{
	GuiControlGet, ContentsSearchField,,SearchString
	return ContentsSearchField
}

::alib.s::
Numpad0::
GUI_Mode:=!GUI_Mode
if WinActive(GuiNameMain)
    fGuiHide_1()
else
    fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
if strsplit(script.config.settings.ShowRedraw,A_Space).1
	GuiControl, +Redraw, LVvalue
f_RescaleLV()
if !strsplit(script.config.settings.ShowRedraw,A_Space).1
	GuiControl, +Redraw, LVvalue
return 

fSelectFirstLVEntry_Searches()
{
	SendInput, {Down}{Up}
}

MoveOnListView(Direction:=1)
{
	sleep, 150
	SendInput, % str:="{" ((Direction==1)?"Down":"Up") "}"
	
	; fLV_Callback()
	return
}



lSelectFirstLVEntry:
fSelectFirstLVEntry_Searches()
fLV_Callback()
return
; ListViewUp:
; ListViewDown:
; sleep, 150
; If !InStr(A_ThisLabel, "ListViewUp") & !InStr(A_ThisLabel,"ListViewDown")
; 	Send, {Up}
; if !InStr(A_ThisLabel, "ListViewUp") & !InStr(A_ThisLabel,"ListViewDown")
; 	Send, {Down}
ListViewSelect:	;; 

	if Instr(A_ThisLabel,"ListViewSelect")
	SendInput, {LButton}
; selRow:= LV_GetNext("F")
if Instr(A_ThisLabel,"fSelectFirstLVEntry_Searches")
{
	
}
else
	fLV_Callback()
return

#If WinActive(GuiNameMain)
Esc::
gui, 1: hide
return
Numpad9::
bSwitchSize:=1
if (vGuiHeight==(1080-20))
{
	vGUIWidth:=A_ScreenWidth*1.0 - 20  ;-910 ; 0.6@1440 starts clipping
	, vGUIHeight:=MonBottom*1.0 - 20 
}
else
{
	vGuiHeight:=1080-20
	, vGuiWidth:=1920-20
}
gosub, lGUICreate_1New
return
#if Winactive(GuiNameIngestion)
Esc::
gui, 2: destroy
gui, 1: show
return
#If (A_ComputerName=script.AuthorID?1:0) 
!esc::
SendInput, ^s  
reload
return ; yes I know this is not actually needed. I don't care.

/*
	Not planned further right now.
	f_SB_Set(Text,PartNumber)
	{

	}

	CollectMatchesAcrossObject(Object,String)
	{

		out:={}
		KeyVals:={}
		pos := 1
		String:=TRIM(strreplace(String,"AU:","`nAU:"))
		String:=TRIM(strreplace(String,"LI:","`nLI:"))
		String:=TRIM(strreplace(String,"SE:","`nSE:"))
		StringO:=String
		; ; String=
		; (LTRIM
		; AU:Gew
		; SE:clipboard and 
		; Li:wtf v312
		; )
		regex:="(LI|AU|SE):(.+?)`n"
		while RegExMatch(String "`n", "im)" regex, match, pos)
		{
			KeyVals[match1]:=Trim(match2)
			pos+=strlen(match)
		}

		;; now we have keyvals: contains which author/section/license to search for




		for k,v in Object
		{
			if script.config.settings.Search_InString_MetaFields
			{
				if InStr(k,String)
				{
					Str:=(SubStr(v,0)=",")?SubStr(v,1,StrLen(v)-1):v
					for s,w in strsplit(Str,",")
						out.push(w)
				}
			}
			else 
			{
				if (k=String)
				{
					Str:=(SubStr(v,0)=",")?SubStr(v,1,StrLen(v)-1):v
					out.push(strsplit(Str,","))
				}
			}

		}
		return out
	}
*/
f_CollectMatches(Array,String,References,AllSections)
{ ;; finds all fields of Array whose value contain 'String', and if any exist return the snippet's Object
	;; TODO: this function can probably be improved :P
	Matches:=[]
	Matches2:=[]
	MatchedLibraries:=[]
	KeyVals:={}
	AddedOnes:=""
	Map:={AU:1 ;; For fetching data from 'References'
	,Se:2
	,Li:3
	,Da:4
	,Fi:5}
	Map2:={AU:"Author" ;; For fetching data from 'Matches', the presorted object
	,DA:"Date"
	,Fi:"Library"
	,Li:"License"
	,Na:"Name"
	,Se:"Section"
	,Url:"URL"
	,Ver:"Version"}


	str:=""
	pos := 1
	regex:="(AU|DA|FI|LI|NA|SE|URL|VER):(.+?)`n"
	     
	if (String="") || (StrLen(Trim(String))=0) ;; the string is entirely empty/spaces/tabs
		return
	;; If a snippet is matches in one 
		;; 0. Name			 || done
		;; 1. Author-Search  || done
		;; 2. Section-Search || done
		;; 3. License-Match  || done
	
	;; 4. DateMatch
		;; 5. Combined? 
	
	;; make sure formatting is clean
	String:=TRIM(strreplace(String,"AU:","`nAU:"))
	String:=TRIM(strreplace(String,"DA:","`nDA:"))
	String:=TRIM(strreplace(String,"FI:","`nFI:"))
	String:=TRIM(strreplace(String,"LI:","`nLI:"))
	String:=TRIM(strreplace(String,"NA:","`nNA:"))
	String:=TRIM(strreplace(String,"SE:","`nSE:"))
	String:=TRIM(strreplace(String,"URL:","`nURL:"))
	String:=TRIM(strreplace(String,"VER:","`nVER:"))

	;; setup, get key-value pairs
	while RegExMatch(String "`n", "im)" regex, match, pos)
	{
		KeyVals[match1]:=Trim(match2)
		pos+=strlen(match)
	}
	if (KeyVals.Count()=0)
	{
		KeyVals.NA:=String
	}
	for k,v in KeyVals
	{
		for s,w in References[Map[k]]
		{
			if (k="DA")
			{
				
				if Instr(s,NewDate:=DateParse(v))
					str.="," w ;; for each KeyVal-Pair, add the locations of those snippets which are referenced to the string.
			}
			else
			{
				if Instr(s,v)
					str.="," w ;; for each KeyVal-Pair, add the locations of those snippets which are referenced to the string.
			}
		}
	}
	;; this is all bugged. choosing "Fi:Libr AU:ano" should return 0 results, because 'anon1184 is' 'Secondlib'-exclusive, and 'Libr' is 'Library'-exclusing, mututally excluding each other
	Numbers:=strsplit(str,",")	;; this entire step up until the for 'k,v in Repetitions'-loop is unnecessary, but can't be avoided cuz idk how :P || In theory, this could be skipped, if I knew how to parse the string properly to decect repeating numbers properly.
	Repetitions:={}
	for k,v in Numbers
	{
		if (v="")
			continue
		if (Repetitions[v+0]="")
			Repetitions[v+0]:=0
		else
			Repetitions[v+0]++
	}
	;; DateParse(str)
	for k,v in Repetitions
	{
		if (v<1) && (KeyVals.Count()>1) ;; pesky workaround for allowing queries that have only one parameter
			continue
		Matches.push(Array[k])
	}
/*

		; 		if KeyVals.AU=""
		; 		{
		; /*
		; str = the dog went for a run with another dog
		; match = dog

		; msgbox % "Found " ( count, regexReplace( str
		; 		 , "(" match ")", match, count ))
		; 		 . " instance" ( count!=1 ? "s" : "" )
		; 		 . " of " match "."
		; */
		; 		}
		; 		if e:=RegExMatch(String, "i)(AU\:)(?<Author>.*)(\s|\:)*",v)
		; 		{
		; 			Result:=CollectMatchesAcrossObject(References[1],String)
		; 			; Result:=CollectMatchesAcrossObject(References[1],vAuthor)
		; 			for k,v in Result ;strsplit(References[1,vAuthor],",")  ;; this only allows for exact author-matches, but not for an approx-/instr match
		; 			{
		; 				if InStr(Added,Array[v].Metadata.Hash)
		; 					continue ;; skip if the snippet is already added
		; 				out.push(Array[v])
		; 				Added.=Array[v].Metadata.Hash ", " ;; used for quick lookup on what we can skip further down the road
		; 			}
		; 		}
		; 		;;2.
		; 		; ttip("Figure out what the (\+)-capturing group in these two regexes was for :P")
		; 		if RegExMatch(String, "i)(SE\:)(?<Section>.*)(\+)",v)
		; 		{
		; 			Result:=CollectMatchesAcrossObject(References[2],vSection)
		; 			; d:=strsplit(References[2,vSection],",")
		; 			for k,v in Result[1]
		; 			{
		; 				if InStr(Added,Array[v].Metadata.Hash)
		; 					continue ;; skip if the snippet is already added
		; 				out.push(Array[v])
		; 				Added.=Array[v].Metadata.Hash ", "

		; 			}
		; 		}
		; 		if RegExMatch(String, "i)(LI\:)(?<License>.+)",v)
		; 		{
		; 			Result:=CollectMatchesAcrossObject(References[3],vLicense)
		; 			; d:=strsplit(References[2,vLicense],",")
		; 			for k,v in Result[1]
		; 			{
		; 				if InStr(Added,Array[v].Metadata.Hash)
		; 					continue ;; skip if the snippet is already added
		; 				out.push(Array[v])
		; 				Added.=Array[v].Metadata.Hash ", "

		; 			}
		; 		}
*/		
	; ttip(";; this entire sectio	n is painful bs. #important#todo: figure out how to remove so that 'Fi:Libr AU:ano' will net 0 results in the current configuration","the issue is that the smarter solution above doesn't work flawlessly, and that","this is a flawed implementation of a fix")
	if (Matches.Count()=0)
		Matches:=Array.Clone()

	if (Matches.Count()=Array.Count())
	{
		Matches1:=[]
		Threshold:=KeyVals.Count()
		for s,w in Matches
		{
			MatchCount:=0
			for k,v in KeyVals
			{
				SearchedStr:=Matches[s,"MetaData",Map2[k]]
				Needle:=(k="DA")?DateParse(v):v
				if script.config.settings.Search_InString_MetaFields
				{
					if InStr(SearchedStr,needle)
					{
						MatchCount++
						; Matches2.push(w)
						; MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
					}
				}
				else
				{
					if (SearchedStr=needle)
					{
						MatchCount++
						; Matches2.push(w)
						; MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
					}
				}
				if MatchCount=Threshold
				{

				}
			}
				if (MatchCount=Threshold)
				{
					Matches2.push(w)
					MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
				}
		}
	}
	else
	{

		for k,v in KeyVals  ;; and finally, remove the faultily-added entry which does not conform in LI
		{
			if Instr("AU,SE",k) ;; pre-handled already
			{
				for s,w in Matches
				{
					Matches2.push(w)
					MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
					AddedOnes.=w.Metadata.Hash ", "
				}

				continue
			}
			for s,w in Matches
			{
				; if instr(w.Metadata.Library,"second")
				; 	{
					;; Catcher for quicker testing	
				; 	}
				SearchedStr:=Matches[s,"MetaData",Map2[k]]
				Needle:=(k="DA")?DateParse(v):v
				if script.config.settings.Search_InString_MetaFields
				{
					if InStr(SearchedStr,needle)
					{
						if Instr(AddedOnes,w.Metadata.Hash)
							continue
						Matches2.push(w)
						MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
					}
				}
				else
				{
					if (SearchedStr=needle)
					{
						if Instr(AddedOnes,w.Metadata.Hash) ;; fucking hell.
							continue
						Matches2.push(w)
						MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
					}
				}
			}
		}
	}
	; m(Matches2)
	
 	return (Matches2.Count()>0 && Matches2.Count()!="")?[Matches2,AllSections,MatchedLibraries.Count()]:-1 ;; throw a -1 if something went wrong.
}


HasVal(haystack, needle) 
{	; code from jNizM on the ahk forums: https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

f_GetSelectedLVEntries(Number:="")
{ ; Get Values from selected row in LV A_DefaultListView
    vRowNum:=0
	, sel:=[]
	if (Number="")
	{
		loop 
		{
			fFocusListView()
			vRowNum:=LV_GetNext(vRowNum)
			if not vRowNum  ; The above returned zero, so there are no more selected rows.
				break
				; LV_Add("-E0x200",		Addition.LVSection,		Addition.Name,		Addition.Hash,		Addition.LibraryName,		Addition.LVIdentifier		)
			LV_GetText(sCurrText1,vRowNum,1) ; SectionInd - SectionName
			LV_GetText(sCurrText2,vRowNum,2) ; Name
			LV_GetText(sCurrText3,vRowNum,3) ; Hash
			LV_GetText(sCurrText4,vRowNum,4) ; LibraryName
			LV_GetText(sCurrText5,vRowNum,5) ; LVIdentifier
			LV_GetText(sCurrText6,vRowNum,6) ; AdditionIndex

			LV_GetText(sCurrText7,vRowNum,7) ; License
			LV_GetText(sCurrText8,vRowNum,8) ; Version
			LV_GetText(sCurrText9,vRowNum,9) ; Author
			sel[A_Index]:={SelectedEntrySection:sCurrText1
			,SelectedEntryName:sCurrText2
			,Hash:sCurrText3
			,Library:sCurrText4
			,SelectedEntrySnippetIdentifier:sCurrText5
			,AdditionIndex:sCurrText6
			,License:sCurrText7
			,Version:sCurrText8
			,Author:sCurrText9}
			; sel[A_Index]:={SelectedEntrySection:sCurrText1,SelectedEntryName:sCurrText2,Hash:sCurrText3,Library:sCurrText4,SelectedEntrySnippetIdentifier:sCurrText5,AdditionIndex:sCurrText6}
					; LV_GetText(sCurrText6,vRowNum,6)
			return [sel,vRowNum,sCurrText6]
		}
	}
	Else
	{
		loop
		{
			vRowNum:=LV_GetNext(vRowNum)
				; if not vRowNum  ; The above returned zero, so there are no more selected rows.
					break
		}
			LV_GetText(sCurrText1,Number,1) ; SectionInd - SectionName
			LV_GetText(sCurrText2,Number,2) ; Name
			LV_GetText(sCurrText3,Number,3) ; Hash
			LV_GetText(sCurrText4,Number,4) ; LibraryName
			LV_GetText(sCurrText5,Number,5) ; LVIdentifier
			LV_GetText(sCurrText6,Number,6) ; AdditionIndex

			LV_GetText(sCurrText7,Number,7) ; License
			LV_GetText(sCurrText8,Number,8) ; Version
			LV_GetText(sCurrText9,Number,9) ; Author
			sel[(vRowNum=0?1:vRowNum)]:={SelectedEntrySection:sCurrText1
			,SelectedEntryName:sCurrText2
			,Hash:sCurrText3
			,Library:sCurrText4
			,SelectedEntrySnippetIdentifier:sCurrText5
			,AdditionIndex:sCurrText6
			,License:sCurrText7
			,Version:sCurrText8
			,Author:sCurrText9}
			return [sel,(vRowNum=0?1:vRowNum),sCurrText6]

	}
}

fPopulateLVNew(Snippets,SectionNames,LibraryCount)
{
    LV_Delete()
	SectionPad:=(SectionPad!=""?SectionPad:"") ;; this is fucking painful that I can't just have a variable be _static_ so I only actually have to declare it once. _ugh_
	NewSnippetsSorted:=[]
	, ErrorIndex:=1
	, SectionIndexLength:=(StrLen(SectionNames.MaxIndex())>SectionIndexLength?StrLen(SectionNames.MaxIndex()):SectionIndexLength)
	, SectionNamesReversed:=[]
	, SectionNamesRespectiveIndex:=[]
	, AuthorReferences:=[]
	, LicenseReferences:=[]
	, SectionReferences:=[]
	, DateReferences:=[]
	, FileReferences:=[]

	for k,v in SectionNames
	{
		SectionNamesReversed[v]:=k
		SectionNamesRespectiveIndex[v]:=0	;; create a double-sided map to get the respective section's ID immediately without the need for double-looping when assigning section-unique aligned IDs
	}
	
	loop, % (SectionPad=""?SectionIndexLength:0)
		SectionPad.="0"
	;; new Snippet Indexing ensures that snippet identifiers across each section constitute a list from 1 → Section.Count(), instead of treating section and snippet identifier separately.
	for k,v in Snippets
	{
		if !InStr(A_ThisLabel,"lSearchSnippets")		;; this fucking line's nonexistence caused me so much pain and hurt so far.
		{
				SectionNamesRespectiveIndex[v.Metadata.Section]++
				, AuthorReferences[v.Metadata.Author]:=AuthorReferences[v.Metadata.Author] k ","
				, LicenseReferences[v.Metadata.License]:=LicenseReferences[v.Metadata.License] k ","
				, SectionReferences[v.Metadata.Section]:=SectionReferences[v.Metadata.Section] k ","
				, DateReferences[v.Metadata.Date]:=DateReferences[v.Metadata.Date] k ","
				, FileReferences[v.Metadata.Library]:=FileReferences[v.Metadata.Library] k ","
				, v.MetaData.LVInd:=fPadIndex(SectionNamesRespectiveIndex[v.Metadata.Section],Snippets.Count())
				, v.MetaData.SectionInd:=fPadIndex(SectionNamesReversed[v.Metadata.Section],Snippets.Count())
				; ; TempInd:=SectionNamesRespectiveIndex[v.Metadata.Section]++
				; Clipboard:=SectionNamesRespectiveIndex[v.Metadata.Section]	
		}
		Addition:=[] ;; remove all of these and move them into the LV_Add instead, then comment this one out as a help for understanding later
		, Addition.LVSection:=(fPadIndex(v.MetaData.SectionInd,SectionPad)) " - " (strlen(v.MetaData.Section)<=0?"-1 INVALIDSECTIONKEY":v.MetaData.Section)
		, Addition.Name:=v.MetaData.Name
		, Addition.Hash:=v.MetaData.Hash
		, Addition.LibraryName:=v.MetaData.Library
		, Addition.LVIdentifier:=fPadIndex(v.MetaData.SectionInd,SectionPad) "." fPadIndex((InStr(A_ThisLabel,"lSearchSnippets")?v.MetaData.LVInd:v.MetaData.LVInd),SectionPad)
		, Addition.AdditionIndex:=k
		, Addition.License:=v.Metadata.License
		, Addition.Version:=v.Metadata.Version
		, Addition.Author:=v.Metadata.Author
		LV_Add("-E0x200",		Addition.LVSection,		Addition.Name,		Addition.Hash,		Addition.LibraryName,		Addition.LVIdentifier, Addition.AdditionIndex, Addition.License, Addition.Version,Addition.Author,Addition.LVIdentifier		)
	}
	; m(d,Snippets.Count())
	guicontrol,,vSearchFunctions,% Snippets.count() " snippets loaded from " LibraryCount  ((LibraryCount>1)?" libraries":" library")
	sleep, 300
	return [AuthorReferences,SectionReferences,LicenseReferences,DateReferences,FileReferences]
}

f_RescaleLV()
{ ;; makes sure the ListView is correctly scaled. ;;TODO: change the order/settings here to hide 
	if (!(script.computername==script.authorID)) && !script.config.settings.bDebugSwitch
	{
		LV_ModifyCol(3,0)
		LV_ModifyCol(5,0)
		LV_ModifyCol(6,0) 
		LV_ModifyCol(7,0) 
		LV_ModifyCol(8,0) 
		LV_ModifyCol(9,0) 
	}
	else if ((script.computername==script.authorID) || (!(script.computername==script.authorID) && script.config.settings.bDebugSwitch))
	{
		LV_ModifyCol(5,0)
		LV_ModifyCol(3,"AutoHdr") 
		LV_ModifyCol(6,"AutoHdr") 
		LV_ModifyCol(7,"AutoHdr") 
		LV_ModifyCol(8,"AutoHdr") 
		LV_ModifyCol(9,"AutoHdr") 

	}
	LV_ModifyCol(4,"Right")
    ; , LV_ModifyCol(3,"AutoHdr")
    , LV_ModifyCol(1,"AutoHdr")
	, LV_ModifyCol(4,"AutoHdr")
    , LV_ModifyCol(2,"AutoHDr")
    , LV_ModifyCol(10,"Right")
	, LV_ModifyCol(10,"AutoHdr")
	, LV_ModifyCol(10,"Sort")
}

f_FillFields(Code,Description,Example)
{ ;; inserts Code/Desc/Ex into the respective RichField-Controls
 	RC.Settings.Highlighter := "HighlightAHK"
	, RC.Value := []
	, RC.Value:=code
	, RC2.Value:=Description
	, RC3.Value:=Example
	return
}

f_FindSectionName(ThisSec)
{
    return SectionNames[strsplit(ThisSec,".").1]
}

ControlIsFocused(ControlID)                                                                   	;-- true or false if specified gui control is active or not
{
	GuiControlGet, FControlID, 1:Focus
	return (InStr(FControlID, ControlID)?true:false)
	/*
	TODO: fix this returning true when I _don't_ click on RC-fields, but f.e. on the disabled Description-Editfield or the bottom part of the LV-Control
	*/
}

floadFolderLibraries()
{	;; new method of loading snippets by separating data and 
	global DirectoryPath:= A_ScriptDir "\Sources\*" ;; this is the path that contains all libraries which will be read.
	Arr:={}
	, SectionNames:=[]
	, SectionNamesIntern:=[]
	, SectionReferences:=[]
	, k:=1
	, LibrariesKnown:=[]
	, FileTypeCount:={ahk:0
		, description:0
		, example:0
		, ini:0}
	loop, files, % DirectoryPath, FR
	{

 		SplitPath, % A_LoopFileFullPath,FileName,DirName,Ext,NameNExt,Drive
		FileTypeCount[Ext]++
		if !Instr(SubStr(A_LoopFileFullPath,-3),"ini")
			continue
		
		; if Instr(".Description,.Example,.ahk,",Ext)
		; 	Continue
		;; preset these fields
		; if (k<3) ;; preload the first example
		; {
		; 	Arr[k,"Code"]:="" 			
		; 	, Arr[k,"Example"]:=""
		; 	, Arr[k,"Description"]:=""
		; }
		; else
		{

			Arr[k,"Code"]:="" 			
			, Arr[k,"Example"]:=""
			, Arr[k,"Description"]:=""
		}
		
		if Instr(A_LoopFileFullPath,"alib")
		{
			if !FileExist(DirName "\" NameNExt ".ahk") && !FileExist(DirName "\" NameNExt ".description") && !FileExist(DirName "\" NameNExt ".example")
			{

			}
		}
		;; Insert Metadata from file and add the current library-(==folder-)name
		; Info:=fReadINI(strreplace(A_LoopFileFullPath, ".ahk",".ini")).Info
		Info:=fReadINI(A_LoopFileFullPath).Info
		if !(Info.Count()>0)
			msgbox, % "Error: metadata not found in file '" A_LoopFileFullPath "'."
		Arr[k,"Metadata"]:=Info
		, LibrariesKnown[Arr[k,"Metadata","Library"]:=strsplit(DirName,"\")[strsplit(DirName,"\").MaxIndex()]]:=1
		if !HasVal(SectionNamesIntern,Info.Section)
		{ ;; collect a list of sectionnames
			SectionNamesIntern.push(Info.Section)
			; SectionNames.push(Info.Section " - " SectionNames.Count()+1)
			, SectionNames.push(Info.Section) ;" - " SectionNames.Count()+1)
			, SectionReferences[Info.Section]:=SectionReferences[Info.Section] "|||"  k
		}
		k++
	}
	; ttip("Decide if we want all snippets in the same obj, or if we want to subobjectivise them by keeping the folderstructure within as a 1st-lvl-object differentiation.","Currently, the Section")
	return [Arr,SectionNames,LibrariesKnown.Count(),FileTypeCount]
}

fReadINI(INI_File,bIsVar=0) ; return 2D-array from INI-file, or alternatively from a string with the same format.
{
	Result := []
	if !bIsVar ; load a simple file
	{
		SplitPath, INI_File,, WorkDir
		OrigWorkDir:=A_WorkingDir
		SetWorkingDir, % WorkDir
		IniRead, SectionNames, %INI_File%
		for each, Section in StrSplit(SectionNames, "`n") {
			IniRead, OutputVar_Section, %INI_File%, %Section%
			for each, Haystack in StrSplit(OutputVar_Section, "`n")
			{
				if (Instr(Haystack, "="))
				{
					RegExMatch(Haystack, "(.*?)=(.*)", $)
				, Result[Section, $1] := $2
				}
				else			;; path for pushing just values, without keys into ordered arrays. Be aware that no error prevention is present, so mixing assoc. and linear array - types in the middle of an array will result in erroneous structures.
					Result[Section,each]:=Haystack
			}
		}
		if A_WorkingDir!=OrigWorkDir
			SetWorkingDir, %OrigWorkDir%
	}
	else ; convert string
	{
		Lines:=StrSplit(bIsVar,"`n")
		, bIsInSection:=false
		for k,v in lines
		{
			If (SubStr(v,1,1)="[") && (SubStr(v,StrLen(v),1)="]")
			{
				SectionHeader:=SubStr(SubStr(v,2),1,StrLen(SubStr(v,2))-1)
				, bIsInSection:=true
				, currentSection:=SectionHeader
			}
			if bIsInSection
			{
				RegExMatch(v, "(.*?)=(.*)", $)
				if ($2!="")
					Result[currentSection,$1] := $2
			}
		}
	}
	return Result
	/* Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
	;-------------------------------------------------------------------------------
		ReadINI(INI_File) { ; return 2D-array from INI-file
	;-------------------------------------------------------------------------------
			Result := []
			IniRead, SectionNames, %INI_File%
			for each, Section in StrSplit(SectionNames, "`n") {
				IniRead, OutputVar_Section, %INI_File%, %Section%
				for each, Haystack in StrSplit(OutputVar_Section, "`n")
					RegExMatch(Haystack, "(.*?)=(.*)", $)
			, Result[Section, $1] := $2
			}
			return Result
	*/
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

fPadIndex(snippet,aSnippets)
{ ; pads snippet indeces to the maximum number of snippets loaded.
	if IsObject(snippet)
	{
		StrLenDiff:=MaxLenNecessary-StrLen(snippet.Ind)
		if (StrLenDiff>0)
			snippet.Ind:=ALG_st_pad(snippet.Ind,"0","",StrLenDiff,0) +0
		return snippet
	}
	else
		return ALG_st_pad(snippet,"0","",(StrLen(aSnippets)-StrLen(snippet))) ; + 0
}


ALG_st_split(string, delim="`n", exclude="`r")
{
   arr:=[]
   loop, parse, string, %delim%, %exclude%
      arr.insert(A_LoopField)
   return arr
}

ALG_st_pad(string, left="0", right="", LCount=1, RCount=1)
{
   if (LCount>0)
   {
      if (LCount>1)
         loop, %LCount%
            Lout.=left
      Else
         Lout:=left
   }
   if (RCount>0)
   {
      if (RCount>1)
         loop, %RCount%
            Rout.=right
      Else
         Rout.=right
   }
   Return Lout string Rout
}

ALG_st_Insert(insert,input,pos=1)
{
	Length := StrLen(input)
	, ((pos > 0) ? (pos2 := pos - 1) : (((pos = 0) ? (pos2 := StrLen(input),Length := 0) : (pos2 := pos))))
	, output := SubStr(input, 1, pos2) . insert . SubStr(input, pos, Length)
	If (StrLen(output) > StrLen(input) + StrLen(insert))
		((Abs(pos) <= StrLen(input)/2) ? (output := SubStr(output, 1, pos2 - 1) . SubStr(output, pos + 1, StrLen(input))) : (output := SubStr(output, 1, pos2 - StrLen(insert) - 2) . SubStr(output, pos - StrLen(insert), StrLen(input))))
	return, output
}

Object2String(Obj,FullPath:=1,BottomBlank:=0)
{
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b))
				Object2String(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " b "`n"
				else if(b!="")
					String.=FullPath "." a " = " b "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}

AddToolTip(_CtrlHwnd, _TipText, _Modify = 0) 			;-- very easy to use function to add a tooltip to a control
{ ; AddToolTip | retrieved from AHK-Rare Repository, original by jballi: https://www.autohotkey.com/boards/viewtopic.php?t=30079

	; retrieved from AHK-Rare Repository, original by jballi: https://www.autohotkey.com/boards/viewtopic.php?t=30079

		/*                              	DESCRIPTION

				Adds Multi-line ToolTips to any Gui Control
				AHK basic, AHK ANSI, Unicode x86/x64 compatible

				Thanks Superfraggle & Art: http://www.autohotkey.com/forum/viewtopic.php?p=188241
				Heavily modified by Rseding91 3/4/2014:
				Version: 1.0
				* Fixed 64 bit support
				* Fixed multiple GUI support
				* Changed the _Modify parameter
						* blank/0/false:                                	Create/update the tool tip.
						* -1:                                           		Delete the tool tip.
						* any other value:                             Update an existing tool tip - same as blank/0/false
																					but skips unnecessary work if the tool tip already
																					exists - silently fails if it doesn't exist.
				* Added clean-up methods:
						* AddToolTip(YourGuiHwnd, "Destroy", -1):       		Cleans up and erases the cached tool tip data created
																				for that GUI. Meant to be used in conjunction with
																				GUI, Destroy.
							* AddToolTip(YourGuiHwnd, "Remove All", -1):	   	Removes all tool tips from every control in the GUI.
																				Has the same effect as "Destroy" but first removes
																				every tool tip from every control. This is only used
																				when you want to remove every tool tip but not destroy
																				the entire GUI afterwords.
						* NOTE: Neither of the above are required if
									your script is closing.

				- 'Text' and 'Picture' Controls requires a g-label to be defined.
				- 'ComboBox' = Drop-Down button + Edit (Get hWnd of the 'Edit'   control using "ControlGet" command).
				- 'ListView' = ListView + Header       (Get hWnd of the 'Header' control using "ControlGet" command).

	*/

	Static TTHwnds, GuiHwnds, Ptr
	, LastGuiHwnd
	, LastTTHwnd
	, TTM_DELTOOLA := 1029
	, TTM_DELTOOLW := 1075
	, TTM_ADDTOOLA := 1028
	, TTM_ADDTOOLW := 1074
	, TTM_UPDATETIPTEXTA := 1036
	, TTM_UPDATETIPTEXTW := 1081
	, TTM_SETMAXTIPWIDTH := 1048
	, WS_POPUP := 0x80000000
	, BS_AUTOCHECKBOX = 0x3
	, CW_USEDEFAULT := 0x80000000

	Ptr := A_PtrSize ? "Ptr" : "UInt"

		/*                              	NOTE

					This is used to remove all tool tips from a given GUI and to clean up references used
					This can be used if you want to remove every tool tip but not destroy the GUI
					When a GUI is destroyed all Windows tool tip related data is cleaned up.
					The cached Hwnd's in this function will be removed automatically if the caching code
					ever matches them to a new GUI that doesn't actually own the Hwnd's.
					It's still possible that a new GUI could have the same Hwnd as a previously destroyed GUI
					If such an event occurred I have no idea what would happen. Either the tool tip
					To avoid that issue, do either of the following:
						* Don't destroy a GUI once created
					NOTE: You do not need to do the above if you're exiting the script Windows will clean up
					all tool tip related data and the cached Hwnd's in this function are lost when the script
					exits anyway.AtEOF
	*/

	If (_TipText = "Destroy" Or _TipText = "Remove All" And _Modify = -1)
	{
		; Check if the GuiHwnd exists in the cache list of GuiHwnds
		; If it doesn't exist, no tool tips can exist for the GUI.
		;
		; If it does exist, find the cached TTHwnd for removal.
		Loop, Parse, GuiHwnds, |
			If (A_LoopField = _CtrlHwnd)
		{
			TTHwnd := A_Index
			, TTExists := True
			Loop, Parse, TTHwnds, |
				If (A_Index = TTHwnd)
				TTHwnd := A_LoopField
		}

		If (TTExists)
		{
			If (_TipText = "Remove All")
			{
				WinGet, ChildHwnds, ControlListHwnd, ahk_id %_CtrlHwnd%

				Loop, Parse, ChildHwnds, `n
					AddToolTip(A_LoopField, "", _Modify) ;Deletes the individual tooltip for a given control if it has one

				DllCall("DestroyWindow", Ptr, TTHwnd)
			}

			GuiHwnd := _CtrlHwnd
			; This sub removes 'GuiHwnd' and 'TTHwnd' from the cached list of Hwnds
			GoSub, RemoveCachedHwnd
		}

		Return
	}

	If (!GuiHwnd := DllCall("GetParent", Ptr, _CtrlHwnd, Ptr))
		Return "Invalid control Hwnd: """ _CtrlHwnd """. No parent GUI Hwnd found for control."

	; If this GUI is the same one as the potential previous one
	; else look through the list of previous GUIs this function
	; has operated on and find the existing TTHwnd if one exists.
	If (GuiHwnd = LastGuiHwnd)
		TTHwnd := LastTTHwnd
	Else
	{
		Loop, Parse, GuiHwnds, |
			If (A_LoopField = GuiHwnd)
		{
			TTHwnd := A_Index
			Loop, Parse, TTHwnds, |
				If (A_Index = TTHwnd)
				TTHwnd := A_LoopField
		}
	}

	; If the TTHwnd isn't owned by the controls parent it's not the correct window handle
	If (TTHwnd And GuiHwnd != DllCall("GetParent", Ptr, TTHwnd, Ptr))
	{
		GoSub, RemoveCachedHwnd
		TTHwnd := ""
	}

	; Create a new tooltip window for the control's GUI - only one needs to exist per GUI.
	; The TTHwnd's are cached for re-use in any subsequent calls to this function.
	If (!TTHwnd)
	{
		TTHwnd := DllCall("CreateWindowEx"
			, "UInt", 0 ;dwExStyle
			, "Str", "TOOLTIPS_CLASS32" ;lpClassName
			, "UInt", 0 ;lpWindowName
			, "UInt", WS_POPUP | BS_AUTOCHECKBOX ;dwStyle
			, "UInt", CW_USEDEFAULT ;x
			, "UInt", 0 ;y
			, "UInt", 0 ;nWidth
			, "UInt", 0 ;nHeight
			, "UInt", GuiHwnd ;hWndParent
			, "UInt", 0 ;hMenu
			, "UInt", 0 ;hInstance
		, "UInt", 0) ;lpParam

		; TTM_SETWINDOWTHEME
		DllCall("uxtheme\SetWindowTheme"
			, Ptr, TTHwnd
			, Ptr, 0
		, Ptr, 0)

		; Record the TTHwnd and GuiHwnd for re-use in any subsequent calls.
		TTHwnds .= (TTHwnds ? "|" : "") TTHwnd
		, GuiHwnds .= (GuiHwnds ? "|" : "") GuiHwnd
	}

	; Record the last-used GUIHwnd and TTHwnd for re-use in any immediate future calls.
	LastGuiHwnd := GuiHwnd
	, LastTTHwnd := TTHwnd
		/*
			*TOOLINFO STRUCT*

			UINT        cbSize
			UINT        uFlags
			HWND        hwnd
			UINT_PTR    uId
			RECT        rect
			HINSTANCE   hinst
			LPTSTR      lpszText
			#if (_WIN32_IE >= 0x0300)
				LPARAM    lParam;
			#endif
			#if (_WIN32_WINNT >= Ox0501)
				void      *lpReserved;
			#endif
	*/

	, TInfoSize := 4 + 4 + ((A_PtrSize ? A_PtrSize : 4) * 2) + (4 * 4) + ((A_PtrSize ? A_PtrSize : 4) * 4)
	, Offset := 0
	, Varsetcapacity(TInfo, TInfoSize, 0)
	, Numput(TInfoSize, TInfo, Offset, "UInt"), Offset += 4 ; cbSize
	, Numput(1 | 16, TInfo, Offset, "UInt"), Offset += 4 ; uFlags
	, Numput(GuiHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4 ; hwnd
	, Numput(_CtrlHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4 ; UINT_PTR
	, Offset += 16 ; RECT (not a pointer but the entire RECT)
	, Offset += A_PtrSize ? A_PtrSize : 4 ; hinst
	, Numput(&_TipText, TInfo, Offset, Ptr) ; lpszText
	; The _Modify flag can be used to skip unnecessary removal and creation if
	; the caller follows usage properly but it won't hurt if used incorrectly.
	If (!_Modify Or _Modify = -1)
	{
		If (_Modify = -1)
		{
			; Removes a tool tip if it exists - silently fails if anything goes wrong.
			DllCall("SendMessage"
				, Ptr, TTHwnd
				, "UInt", A_IsUnicode ? TTM_DELTOOLW : TTM_DELTOOLA
				, Ptr, 0
			, Ptr, &TInfo)

			Return
		}

		; Adds a tool tip and assigns it to a control.
		DllCall("SendMessage"
			, Ptr, TTHwnd
			, "UInt", A_IsUnicode ? TTM_ADDTOOLW : TTM_ADDTOOLA
			, Ptr, 0
		, Ptr, &TInfo)

		; Sets the preferred wrap-around width for the tool tip.
		DllCall("SendMessage"
			, Ptr, TTHwnd
			, "UInt", TTM_SETMAXTIPWIDTH
			, Ptr, 0
		, Ptr, A_ScreenWidth)
	}

	; Sets the text of a tool tip - silently fails if anything goes wrong.
	DllCall("SendMessage"
		, Ptr, TTHwnd
		, "UInt", A_IsUnicode ? TTM_UPDATETIPTEXTW : TTM_UPDATETIPTEXTA
		, Ptr, 0
	, Ptr, &TInfo)

	Return
	RemoveCachedHwnd:
		Loop, Parse, GuiHwnds, |
			NewGuiHwnds .= (A_LoopField = GuiHwnd ? "" : ((NewGuiHwnds = "" ? "" : "|") A_LoopField))

		Loop, Parse, TTHwnds, |
			NewTTHwnds .= (A_LoopField = TTHwnd ? "" : ((NewTTHwnds = "" ? "" : "|") A_LoopField))

		GuiHwnds := NewGuiHwnds
		, TTHwnds := NewTTHwnds
		, LastGuiHwnd := ""
		, LastTTHwnd := ""
	Return
}

HighlightAHK(Settings, ByRef Code)
{
	static Flow := "break|byref|catch|class|continue|else|exit|exitapp|finally|for|global|gosub|goto|if|ifequal|ifexist|ifgreater|ifgreaterorequal|ifinstring|ifless|iflessorequal|ifmsgbox|ifnotequal|ifnotexist|ifnotinstring|ifwinactive|ifwinexist|ifwinnotactive|ifwinnotexist|local|loop|onexit|pause|return|settimer|sleep|static|suspend|throw|try|until|var|while"
	, Commands := "autotrim|blockinput|clipwait|control|controlclick|controlfocus|controlget|controlgetfocus|controlgetpos|controlgettext|controlmove|controlsend|controlsendraw|controlsettext|coordmode|critical|detecthiddentext|detecthiddenwindows|drive|driveget|drivespacefree|edit|envadd|envdiv|envget|envmult|envset|envsub|envupdate|fileappend|filecopy|filecopydir|filecreatedir|filecreateshortcut|filedelete|fileencoding|filegetattrib|filegetshortcut|filegetsize|filegettime|filegetversion|fileinstall|filemove|filemovedir|fileread|filereadline|filerecycle|filerecycleempty|fileremovedir|fileselectfile|fileselectfolder|filesetattrib|filesettime|formattime|getkeystate|groupactivate|groupadd|groupclose|groupdeactivate|gui|guicontrol|guicontrolget|hotkey|imagesearch|inidelete|iniread|iniwrite|input|inputbox|keyhistory|keywait|listhotkeys|listlines|listvars|menu|mouseclick|mouseclickdrag|mousegetpos|mousemove|msgbox|outputdebug|pixelgetcolor|pixelsearch|postmessage|process|progress|random|regdelete|regread|regwrite|reload|run|runas|runwait|send|sendevent|sendinput|sendlevel|sendmessage|sendmode|sendplay|sendraw|setbatchlines|setcapslockstate|setcontroldelay|setdefaultmousespeed|setenv|setformat|setkeydelay|setmousedelay|setnumlockstate|setregview|setscrolllockstate|setstorecapslockmode|settitlematchmode|setwindelay|setworkingdir|shutdown|sort|soundbeep|soundget|soundgetwavevolume|soundplay|soundset|soundsetwavevolume|splashimage|splashtextoff|splashtexton|splitpath|statusbargettext|statusbarwait|stringcasesense|stringgetpos|stringleft|stringlen|stringlower|stringmid|stringreplace|stringright|stringsplit|stringtrimleft|stringtrimright|stringupper|sysget|thread|tooltip|transform|traytip|urldownloadtofile|winactivate|winactivatebottom|winclose|winget|wingetactivestats|wingetactivetitle|wingetclass|wingetpos|wingettext|wingettitle|winhide|winkill|winmaximize|winmenuselectitem|winminimize|winminimizeall|winminimizeallundo|winmove|winrestore|winset|winsettitle|winshow|winwait|winwaitactive|winwaitclose|winwaitnotactive"
	, Functions := "abs|acos|array|asc|asin|atan|ceil|chr|comobjactive|comobjarray|comobjconnect|comobjcreate|comobject|comobjenwrap|comobjerror|comobjflags|comobjget|comobjmissing|comobjparameter|comobjquery|comobjtype|comobjunwrap|comobjvalue|cos|dllcall|exception|exp|fileexist|fileopen|floor|func|getkeyname|getkeysc|getkeystate|getkeyvk|il_add|il_create|il_destroy|instr|isbyref|isfunc|islabel|isobject|isoptional|ln|log|ltrim|lv_add|lv_delete|lv_deletecol|lv_getcount|lv_getnext|lv_gettext|lv_insert|lv_insertcol|lv_modify|lv_modifycol|lv_setimagelist|mod|numget|numput|objaddref|objclone|object|objgetaddress|objgetcapacity|objhaskey|objinsert|objinsertat|objlength|objmaxindex|objminindex|objnewenum|objpop|objpush|objrawset|objrelease|objremove|objremoveat|objsetcapacity|onmessage|ord|regexmatch|regexreplace|registercallback|round|rtrim|sb_seticon|sb_setparts|sb_settext|sin|sqrt|strget|strlen|strput|strsplit|substr|tan|trim|tv_add|tv_delete|tv_get|tv_getchild|tv_getcount|tv_getnext|tv_getparent|tv_getprev|tv_getselection|tv_gettext|tv_modify|tv_setimagelist|varsetcapacity|winactive|winexist|_addref|_clone|_getaddress|_getcapacity|_haskey|_insert|_maxindex|_minindex|_newenum|_release|_remove|_setcapacity"
	, Keynames := "alt|altdown|altup|appskey|backspace|blind|browser_back|browser_favorites|browser_forward|browser_home|browser_refresh|browser_search|browser_stop|bs|capslock|click|control|ctrl|ctrlbreak|ctrldown|ctrlup|del|delete|down|end|enter|esc|escape|f1|f10|f11|f12|f13|f14|f15|f16|f17|f18|f19|f2|f20|f21|f22|f23|f24|f3|f4|f5|f6|f7|f8|f9|home|ins|insert|joy1|joy10|joy11|joy12|joy13|joy14|joy15|joy16|joy17|joy18|joy19|joy2|joy20|joy21|joy22|joy23|joy24|joy25|joy26|joy27|joy28|joy29|joy3|joy30|joy31|joy32|joy4|joy5|joy6|joy7|joy8|joy9|joyaxes|joybuttons|joyinfo|joyname|joypov|joyr|joyu|joyv|joyx|joyy|joyz|lalt|launch_app1|launch_app2|launch_mail|launch_media|lbutton|lcontrol|lctrl|left|lshift|lwin|lwindown|lwinup|mbutton|media_next|media_play_pause|media_prev|media_stop|numlock|numpad0|numpad1|numpad2|numpad3|numpad4|numpad5|numpad6|numpad7|numpad8|numpad9|numpadadd|numpadclear|numpaddel|numpaddiv|numpaddot|numpaddown|numpadend|numpadenter|numpadhome|numpadins|numpadleft|numpadmult|numpadpgdn|numpadpgup|numpadright|numpadsub|numpadup|pause|pgdn|pgup|printscreen|ralt|raw|rbutton|rcontrol|rctrl|right|rshift|rwin|rwindown|rwinup|scrolllock|shift|shiftdown|shiftup|space|tab|up|volume_down|volume_mute|volume_up|wheeldown|wheelleft|wheelright|wheelup|xbutton1|xbutton2"
	, Builtins := "base|clipboard|clipboardall|comspec|errorlevel|false|programfiles|true"
	, Keywords := "abort|abovenormal|activex|add|ahk_class|ahk_exe|ahk_group|ahk_id|ahk_pid|all|alnum|alpha|altsubmit|alttab|alttabandmenu|alttabmenu|alttabmenudismiss|alwaysontop|and|autosize|background|backgroundtrans|base|belownormal|between|bitand|bitnot|bitor|bitshiftleft|bitshiftright|bitxor|bold|border|bottom|button|buttons|cancel|capacity|caption|center|check|check3|checkbox|checked|checkedgray|choose|choosestring|click|clone|close|color|combobox|contains|controllist|controllisthwnd|count|custom|date|datetime|days|ddl|default|delete|deleteall|delimiter|deref|destroy|digit|disable|disabled|dpiscale|dropdownlist|edit|eject|enable|enabled|error|exit|expand|exstyle|extends|filesystem|first|flash|float|floatfast|focus|font|force|fromcodepage|getaddress|getcapacity|grid|group|groupbox|guiclose|guicontextmenu|guidropfiles|guiescape|guisize|haskey|hdr|hidden|hide|high|hkcc|hkcr|hkcu|hkey_classes_root|hkey_current_config|hkey_current_user|hkey_local_machine|hkey_users|hklm|hku|hotkey|hours|hscroll|hwnd|icon|iconsmall|id|idlast|ignore|imagelist|in|insert|integer|integerfast|interrupt|is|italic|join|label|lastfound|lastfoundexist|left|limit|lines|link|list|listbox|listview|localsameasglobal|lock|logoff|low|lower|lowercase|ltrim|mainwindow|margin|maximize|maximizebox|maxindex|menu|minimize|minimizebox|minmax|minutes|monitorcount|monitorname|monitorprimary|monitorworkarea|monthcal|mouse|mousemove|mousemoveoff|move|multi|na|new|no|noactivate|nodefault|nohide|noicon|nomainwindow|norm|normal|nosort|nosorthdr|nostandard|not|notab|notimers|number|off|ok|on|or|owndialogs|owner|parse|password|pic|picture|pid|pixel|pos|pow|priority|processname|processpath|progress|radio|range|rawread|rawwrite|read|readchar|readdouble|readfloat|readint|readint64|readline|readnum|readonly|readshort|readuchar|readuint|readushort|realtime|redraw|regex|region|reg_binary|reg_dword|reg_dword_big_endian|reg_expand_sz|reg_full_resource_descriptor|reg_link|reg_multi_sz|reg_qword|reg_resource_list|reg_resource_requirements_list|reg_sz|relative|reload|remove|rename|report|resize|restore|retry|rgb|right|rtrim|screen|seconds|section|seek|send|sendandmouse|serial|setcapacity|setlabel|shiftalttab|show|shutdown|single|slider|sortdesc|standard|status|statusbar|statuscd|strike|style|submit|sysmenu|tab|tab2|tabstop|tell|text|theme|this|tile|time|tip|tocodepage|togglecheck|toggleenable|toolwindow|top|topmost|transcolor|transparent|tray|treeview|type|uncheck|underline|unicode|unlock|updown|upper|uppercase|useenv|useerrorlevel|useunsetglobal|useunsetlocal|vis|visfirst|visible|vscroll|waitclose|wantctrla|wantf2|wantreturn|wanttab|wrap|write|writechar|writedouble|writefloat|writeint|writeint64|writeline|writenum|writeshort|writeuchar|writeuint|writeushort|xdigit|xm|xp|xs|yes|ym|yp|ys|__call|__delete|__get|__handle|__new|__set"
	, Needle :="
	(LTrim Join Comments
		ODims)
		((?:^|\s);[^\n]+)                	; Comments
		|(^\s*\/\*.+?\n\s*\*\/)      	; Multiline comments
		|((?:^|\s)#[^ \t\r\n,]+)      	; Directives
		|([+*!~&\/\\<>^|=?:
			,().```%{}\[\]\-]+)           	; Punctuation
		|\b(0x[0-9a-fA-F]+|[0-9]+)	; Numbers
		|(""[^""\r\n]*"")                	; Strings
		|\b(A_\w*|" Builtins ")\b   	; A_Builtins
		|\b(" Flow ")\b                  	; Flow
		|\b(" Commands ")\b       	; Commands
		|\b(" Functions ")\b          	; Functions (builtin)
		|\b(" Keynames ")\b         	; Keynames
		|\b(" Keywords ")\b          	; Other keywords
		|(([a-zA-Z_$]+)(?=\())       	; Functions
		|(^\s*[A-Z()-\s]+\:\N)        	; Descriptions
	)"

	GenHighlighterCache(Settings)
	Map := Settings.Cache.ColorMap

	Pos := 1
	while (FoundPos := RegExMatch(Code, Needle, Match, Pos))
	{
		RTF .= "\cf" Map.Plain " "
		RTF .= EscapeRTF(SubStr(Code, Pos, FoundPos-Pos))

		; Flat block of if statements for performance
		if (Match.Value(1) != "")
			RTF .= "\cf" Map.Comments
		else if (Match.Value(2) != "")
			RTF .= "\cf" Map.Multiline
		else if (Match.Value(3) != "")
			RTF .= "\cf" Map.Directives
		else if (Match.Value(4) != "")
			RTF .= "\cf" Map.Punctuation
		else if (Match.Value(5) != "")
			RTF .= "\cf" Map.Numbers
		else if (Match.Value(6) != "")
			RTF .= "\cf" Map.Strings
		else if (Match.Value(7) != "")
			RTF .= "\cf" Map.A_Builtins
		else if (Match.Value(8) != "")
			RTF .= "\cf" Map.Flow
		else if (Match.Value(9) != "")
			RTF .= "\cf" Map.Commands
		else if (Match.Value(10) != "")
			RTF .= "\cf" Map.Functions
		else if (Match.Value(11) != "")
			RTF .= "\cf" Map.Keynames
		else if (Match.Value(12) != "")
			RTF .= "\cf" Map.Keywords
		else if (Match.Value(13) != "")
			RTF .= "\cf" Map.Functions
		else If (Match.Value(14) != "")
			RTF .= "\cf" Map.Descriptions
		else
			RTF .= "\cf" Map.Plain

		RTF .= " " EscapeRTF(Match.Value())
		, Pos := FoundPos + Match.Len()
	}

	return Settings.Cache.RTFHeader . RTF . "\cf" Map.Plain " " EscapeRTF(SubStr(Code, Pos)) "\`n}"
}

GenHighlighterCache(Settings)
{

	if Settings.HasKey("Cache")
		return
	Cache := Settings.Cache := {}


	; --- Process Colors ---
	Cache.Colors := Settings.Colors.Clone()

	; Inherit from the Settings array's base
	BaseSettings := Settings
	while (BaseSettings := BaseSettings.Base)
		for Name, Color in BaseSettings.Colors
			if !Cache.Colors.HasKey(Name)
				Cache.Colors[Name] := Color

	; Include the color of plain text
	if !Cache.Colors.HasKey("Plain")
		Cache.Colors.Plain := Settings.FGColor

	; Create a Name->Index map of the colors
	Cache.ColorMap := {}
	for Name, Color in Cache.Colors
		Cache.ColorMap[Name] := A_Index


	; --- Generate the RTF headers ---
	RTF := "{\urtf"

	; Color Table
	RTF .= "{\colortbl;"
	for Name, Color in Cache.Colors
	{
		RTF .= "\red"    	Color>>16	& 0xFF
		, RTF .= "\green"	Color>>8 	& 0xFF
		, RTF .= "\blue"  	Color        	& 0xFF ";"
	}
	RTF .= "}"

	; Font Table
	if Settings.Font
	{
		FontTable .= "{\fonttbl{\f0\fmodern\fcharset0 "
		,FontTable .= Settings.Font.Typeface
		,FontTable .= ";}}"
		,RTF .= "\fs" Settings.Font.Size * 2 ; Font size (half-points)
		if Settings.Font.Bold
			RTF .= "\b"
	}

	; Tab size (twips)
	RTF .= "\deftab" GetCharWidthTwips(Settings.Font) * Settings.TabSize

	Cache.RTFHeader := RTF
}

GetCharWidthTwips(Font)
{

	static Cache := {}

	if Cache.HasKey(Font.Typeface "_" Font.Size "_" Font.Bold)
		return Cache[Font.Typeface "_" font.Size "_" Font.Bold]

	; Calculate parameters of CreateFont
	Height	:= -Round(Font.Size*A_ScreenDPI/72)
	Weight	:= 400+300*(!!Font.Bold)
	Face 	:= Font.Typeface

	; Get the width of "x"
	hDC 	:= DllCall("GetDC", "UPtr", 0)
	hFont 	:= DllCall("CreateFont"
					, "Int", Height 	; _In_ int       	  nHeight,
					, "Int", 0         	; _In_ int       	  nWidth,
					, "Int", 0        	; _In_ int       	  nEscapement,
					, "Int", 0        	; _In_ int       	  nOrientation,
					, "Int", Weight ; _In_ int        	  fnWeight,
					, "UInt", 0     	; _In_ DWORD   fdwItalic,
					, "UInt", 0     	; _In_ DWORD   fdwUnderline,
					, "UInt", 0     	; _In_ DWORD   fdwStrikeOut,
					, "UInt", 0     	; _In_ DWORD   fdwCharSet, (ANSI_CHARSET)
					, "UInt", 0     	; _In_ DWORD   fdwOutputPrecision, (OUT_DEFAULT_PRECIS)
					, "UInt", 0     	; _In_ DWORD   fdwClipPrecision, (CLIP_DEFAULT_PRECIS)
					, "UInt", 0     	; _In_ DWORD   fdwQuality, (DEFAULT_QUALITY)
					, "UInt", 0     	; _In_ DWORD   fdwPitchAndFamily, (FF_DONTCARE|DEFAULT_PITCH)
					, "Str", Face   	; _In_ LPCTSTR  lpszFace
					, "UPtr")
	hObj := DllCall("SelectObject", "UPtr", hDC, "UPtr", hFont, "UPtr")
	VarSetCapacity(SIZE, 8, 0)
	DllCall("GetTextExtentPoint32", "UPtr", hDC, "Str", "x", "Int", 1, "UPtr", &SIZE)
	DllCall("SelectObject", "UPtr", hDC, "UPtr", hObj, "UPtr")
	DllCall("DeleteObject", "UPtr", hFont)
	DllCall("ReleaseDC", "UPtr", 0, "UPtr", hDC)

	; Convert to twpis
	Twips := Round(NumGet(SIZE, 0, "UInt")*1440/A_ScreenDPI)
	Cache[Font.Typeface "_" Font.Size "_" Font.Bold] := Twips
	return Twips
}

EscapeRTF(Code)
{
	for each, Char in ["\", "{", "}", "`n"]
		Code := StrReplace(Code, Char, "\" Char)
	return StrReplace(StrReplace(Code, "`t", "\tab "), "`r")
}

FuzzySearch(string1, string2)
{
	lenl := StrLen(string1)
	, lens := StrLen(string2)
	if(lenl > lens)
	{
		shorter := string2
		, longer := string1
	}
	else if(lens > lenl)
	{
		shorter := string1
		, longer := string2
		, lens := lenl
		, lenl := StrLen(string2)
	}
	else
		return ALG_StringDifference(string1, string2)
	min := 1
	Loop % lenl - lens + 1
	{
		distance := ALG_StringDifference(shorter, SubStr(longer, A_Index, lens))
		if(distance < min)
			min := distance
	}
	return min
}
ALG_StringDifference(string1, string2, maxOffset=1) {    ;returns a float: between "0.0 = identical" and "1.0 = nothing in common" 
	;By Toralf:
	;basic idea for SIFT3 code by Siderite Zackwehdex 
	;http://siderite.blogspot.com/2007/04/super-fast-and-accurate-string-distance.html 
	;took idea to normalize it to longest string from Brad Wood 
	;http://www.bradwood.com/string_compare/ 
	;Own work: 
	; - when character only differ in case, LSC is a 0.8 match for this character 
	; - modified code for speed, might lead to different results compared to original code 
	; - optimized for speed (30% faster then original SIFT3 and 13.3 times faster than basic Levenshtein distance) 
	;http://www.autohotkey.com/forum/topic59407.html 
  If (string1 = string2) 
    Return (string1 == string2 ? 0/1 : 0.2/StrLen(string1))    ;either identical or (assumption:) "only one" char with different case 
  If (string1 = "" OR string2 = "") 
    Return (string1 = string2 ? 0/1 : 1/1) 
  StringSplit, n, string1 
  StringSplit, m, string2 
  ni := 1, mi := 1, lcs := 0 
  While((ni <= n0) AND (mi <= m0)) { 
    If (n%ni% == m%mi%) 
      EnvAdd, lcs, 1 
    Else If (n%ni% = m%mi%) 
      EnvAdd, lcs, 0.8 
    Else{ 
      Loop, %maxOffset%  { 
        oi := ni + A_Index, pi := mi + A_Index 
        If ((n%oi% = m%mi%) AND (oi <= n0)){ 
            ni := oi, lcs += (n%oi% == m%mi% ? 1 : 0.8) 
            Break 
        } 
        If ((n%ni% = m%pi%) AND (pi <= m0)){ 
            mi := pi, lcs += (n%ni% == m%pi% ? 1 : 0.8) 
            Break 
        } 
      } 
    } 
    EnvAdd, ni, 1 
    EnvAdd, mi, 1 
  } 
  Return ((n0 + m0)/2 - lcs) / (n0 > m0 ? n0 : m0) 
}

; fWriteINI(ByRef Array2D, INI_File)  ; write 2D-array to INI-file
; {
;     SplitPath, INI_File, INI_File_File, INI_File_Dir, INI_File_Ext, INI_File_NNE, INI_File_Drive
; 		if (d_fWriteINI_st_count(INI_File,".ini")>0)
; 		{
; 			INI_File:=d_fWriteINI_st_removeDuplicates(INI_File,".ini") ;. ".ini" ; reduce number of ".ini"-patterns to 1
; 			if (d_fWriteINI_st_count(INI_File,".ini")>0)
; 				INI_File:=SubStr(INI_File,1,StrLen(INI_File)-4) ; and remove the last instance
; 		}
; 	if !FileExist(INI_File_Dir) ; check for ini-files directory
; 	{
; 		MsgBox, Creating "INI-Files"-directory at Location`n"%A_ScriptDir%", containing an ini-file named "%INI_File%.ini"
; 		FileCreateDir, % INI_File_Dir
; 	}
; 	OrigWorkDir:=A_WorkingDir
; 	SetWorkingDir, % INI_File_Dir
; 	for SectionName, Entry in Array2D 
; 	{
; 		Pairs := ""
; 		for Key, Value in Entry
;         {
;             ; if (Instr(Key,"Desc") || InStr(Key,"Ex"))
;             ;     Value:=Quote(Value)
; 			Pairs .= Key "=" Value "`n"
;         }
; 		IniWrite, %Pairs%, % Instr(INI_File,".ini")?INI_File:INI_File . ".ini", %SectionName%
; 	}
; 	if A_WorkingDir!=OrigWorkDir
; 		SetWorkingDir, %OrigWorkDir%
;     return
; 	/* Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
		
; 	;-------------------------------------------------------------------------------
; 		WriteINI(ByRef Array2D, INI_File) { ; write 2D-array to INI-file
; 	;-------------------------------------------------------------------------------
; 			for SectionName, Entry in Array2D {
; 				Pairs := ""
; 				for Key, Value in Entry
; 					Pairs .= Key "=" Value "`n"
; 				IniWrite, %Pairs%, %INI_File%, %SectionName%
; 			}
; 		}
; 	*/
; }
; d_fWriteINI_st_removeDuplicates(string, delim="`n")
; { ; remove all but the first instance of 'delim' in 'string'
; 	; from StringThings-library by tidbit, Version 2.6 (Fri May 30, 2014)
; 	/*
; 		RemoveDuplicates
; 		Remove any and all consecutive lines. A "line" can be determined by
; 		the delimiter parameter. Not necessarily just a `r or `n. But perhaps
; 		you want a | as your "line".

; 		string = The text or symbols you want to search for and remove.
; 		delim  = The string which defines a "line".

; 		example: st_removeDuplicates("aaa|bbb|||ccc||ddd", "|")
; 		output:  aaa|bbb|ccc|ddd
; 	*/
; 	delim:=RegExReplace(delim, "([\\.*?+\[\{|\()^$])", "\$1")
; 	Return RegExReplace(string, "(" delim ")+", "$1")
; }
; d_fWriteINI_st_count(string, searchFor="`n")
; { ; count number of occurences of 'searchFor' in 'string'
; 	; copy of the normal function to avoid conflicts.
; 	; from StringThings-library by tidbit, Version 2.6 (Fri May 30, 2014)
; 	/*
; 		Count
; 		Counts the number of times a tolken exists in the specified string.

; 		string    = The string which contains the content you want to count.
; 		searchFor = What you want to search for and count.

; 		note: If you're counting lines, you may need to add 1 to the results.

; 		example: st_count("aaa`nbbb`nccc`nddd", "`n")+1 ; add one to count the last line
; 		output:  4
; 	*/
; 	StringReplace, string, string, %searchFor%, %searchFor%, UseErrorLevel
; 	return ErrorLevel
; }
Quote(String)
{ ; u/anonymous1184 | fetched from https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
	return """" String """"
}
ttip(text:="TTIP: Test",mode:=1,to:=4000,xp:="NaN",yp:="NaN",CoordMode:=-1,to2:=1750,Times:=20,currTip:=20)
{
	/*
		v.0.2.1
		Date: 24 Juli 2021 19:40:56: 
		
		Modes:  
		1: remove tt after "to" milliseconds 
		2: remove tt after "to" milliseconds, but show again after "to2" milliseconds. Then repeat 
		3: not sure anymore what the plan was lol - remove 
		4: shows tooltip slightly offset from current mouse, does not repeat
		5: keep that tt until the function is called again  

		CoordMode:
		-1: Default: currently set behaviour
		1: Screen
		2: Window

		to: 
		Timeout in milliseconds
		
		xp/yp: 
		xPosition and yPosition of tooltip. 
		"NaN": offset by +50/+50 relative to mouse
		IF mode=4, 
		----  Function uses tooltip 20 by default, use parameter
		"currTip" to select a tooltip between 1 and 20. Tooltips are removed and handled
		separately from each other, hence a removal of ttip20 will not remove tt14 

		---
		v.0.2.1
		- added Obj2Str-Conversion via "ttip_Obj2Str()"
		v.0.1.1 
		- Initial build, 	no changelog yet
	
	*/
	
	;if (text="TTIP: Test")
		;m(to)
		cCoordModeTT:=A_CoordModeToolTip
	if (text="") || (text=-1)
		gosub, lRemovettip
	if IsObject(text)
		text:=ttip_Obj2Str(text)
	static ttip_text
	static lastcall_tip
	static currTip2
	global ttOnOff
	currTip2:=currTip
	cMode:=(CoordMode=1?"Screen":(CoordMode=2?"Window":cCoordModeTT))
	CoordMode, % cMode
	tooltip,

	
	ttip_text:=text
	lUnevenTimers:=false 
	MouseGetPos,xp1,yp1
	if (mode=4) ; set text offset from cursor
	{
		yp:=yp1+15
		xp:=xp1
	}	
	else
	{
		if (xp="NaN")
			xp:=xp1 + 50
		if (yp="NaN")
			yp:=yp1 + 50
	}
	tooltip, % ttip_text,xp,yp,% currTip
	if (mode=1) ; remove after given time
	{
		SetTimer, lRemovettip, % "-" to
	}
	else if (mode=2) ; remove, but repeatedly show every "to"
	{
		; gosub,  A
		global to_1:=to
		global to2_1:=to2
		global tTimes:=Times
		Settimer,lSwitchOnOff,-100
	}
	else if (mode=3)
	{
		lUnevenTimers:=true
		SetTimer, lRepeatedshow, %  to
	}
	else if (mode=5) ; keep until function called again
	{
		
	}
	CoordMode, % cCoordModeTT
	return
	lSwitchOnOff:
	ttOnOff++
	if mod(ttOnOff,2)	
	{
		gosub, lRemovettip
		sleep, % to_1
	}
	else
	{
		tooltip, % ttip_text,xp,yp,% currTip
		sleep, % to2_1
	}
	if (ttOnOff>=ttimes)
	{
		Settimer, lSwitchOnOff, off
		gosub, lRemovettip
		return
	}
	Settimer, lSwitchOnOff, -100
	return

	lRepeatedshow:
	ToolTip, % ttip_text,,, % currTip2
	if lUnevenTimers
		sleep, % to2
	Else
		sleep, % to
	return
	lRemovettip:
	ToolTip,,,,currTip2
	return
}

ttip_Obj2Str(Obj,FullPath:=1,BottomBlank:=0)
{
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b))
				ttip_Obj2Str(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " b "`n"
				else if(b!="")
					String.=FullPath "." a " = " b "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}

DateParse(str) 
{ ; 
	/*
		Function: DateParse
			Converts almost any date format to a YYYYMMDDHH24MISS value.

		Parameters:
			str - a date/time stamp as a string

		Returns:
			A valid YYYYMMDDHH24MISS value which can be used by FormatTime, EnvAdd and other time commands.

		Example:
	> time := DateParse("2:35 PM, 27 November, 2007")

		License:
			- Version 1.05 <http://www.autohotkey.net/~polyethene/#dateparse>
			- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
	*/
	static e2 = "i)(?:(\d{1,2}+)[\s\.\-\/,]+)?(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[\s\.\-\/,]+(\d{2,4})"
	str := RegExReplace(str, "((?:" . SubStr(e2, 42, 47) . ")\w*)(\s*)(\d{1,2})\b", "$3$2$1", "", 1)
	If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
		. "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
		. "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i)
		d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
	Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t)
		RegExMatch(str, "i)(\d{1,2})\s*:\s*(\d{1,2})(?:\s*(\d{1,2}))?(?:\s*([ap]m))?", t)
			, RegExMatch(str, e2, d)
	f = %A_FormatFloat%
	SetFormat, Float, 02.0
	d := (d3 ? (StrLen(d3) = 2 ? 20 : "") . d3 : A_YYYY)
		. ((d2 := d2 + 0 ? d2 : (InStr(e2, SubStr(d2, 1, 3)) - 40) // 4 + 1.0) > 0
			? d2 + 0.0 : A_MM) . ((d1 += 0.0) ? d1 : A_DD) . t1
			+ (t1 = 12 ? t4 = "am" ? -12.0 : 0.0 : t4 = "am" ? 0.0 : 12.0) . t2 + 0.0 . t3 + 0.0
	SetFormat, Float, %f%
	Return, d
}

/*   AutoSize/AutoXYWH: Out-Of-Scope for now

	; Original: http://ahkscript.org/boards/viewtopic.php?t=1079
	AutoSize(DimSize, cList*) {				; retrieved from https://www.autohotkey.com/boards/viewtopic.php?p=417609#p417609
		Static cInfo := {}
		Local

		If (DimSize = "reset") {
			Return cInfo := {}
		}

		For i, ctrl in cList {
			ctrlID := A_Gui . ":" . ctrl
			If (cInfo[ctrlID].x = "") {
				GuiControlGet i, %A_Gui%: Pos, %ctrl%
				MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
				fx := fy := fw := fh := 0
				For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) {
					If (!RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)) {
						f%dim% := 1
					}
				}

				If (InStr(DimSize, "t")) {
					GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
					hWndParent := DllCall("GetParent", "Ptr", hWnd, "Ptr")
					VarSetCapacity(RECT, 16, 0)
					DllCall("GetWindowRect", "Ptr", hWndParent, "Ptr", &RECT)
					DllCall("MapWindowPoints", "Ptr", 0, "Ptr"
					, DllCall("GetParent", "Ptr", hWndParent, "Ptr"), "Ptr", &RECT, "UInt", 1)
					ix -= (NumGet(RECT, 0, "Int") * 96) // A_ScreenDPI
					iy -= (NumGet(RECT, 4, "Int") * 96) // A_ScreenDPI
				}

				cInfo[ctrlID] := {x: ix, fx: fx, y: iy, fy: fy, w: iw, fw: fw, h: ih, fh: fh, gw: A_GuiWidth, gh: A_GuiHeight, a: a, m: MMD}

			} Else If (cInfo[ctrlID].a.1) {
				dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw
				dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh

				Options := ""
				For i, dim in cInfo[ctrlID]["a"] {
					Options .= dim . (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) . A_Space
				}

				GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
			}
		}
	}
	AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
		static cInfo := {}
		
		If (DimSize = "reset")
			Return cInfo := {}
		
		For i, ctrl in cList {
			ctrlID := A_Gui ":" ctrl
			If ( cInfo[ctrlID].x = "" ){
				GuiControlGet, i, %A_Gui%:Pos, %ctrl%
				MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
				fx := fy := fw := fh := 0
				For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
					If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
						f%dim% := 1
				cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
			}Else If ( cInfo[ctrlID].a.1) {
				dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
				For i, dim in cInfo[ctrlID]["a"]
					Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
				GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
	} } }
*/
#Include <RichCode>
;#Include <Func_IniSettingsEditor_v6>
; #Include D:\Dokumente neu\AutoHotkey\Lib\ObjTree\Attach.ahk
; #Include D:\Dokumente neu\AutoHotkey\Lib\ObjTree\LV.ahk
; #Include D:\Dokumente neu\AutoHotkey\Lib\ObjTree\ObjTree.ahk
#Include %A_ScriptDir%\Editor\Editor.ahk
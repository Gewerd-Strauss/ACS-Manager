 /*
	TODO:::: Make the script language-agnostic (replace ".ahk"-filetype references with any file of same name for any  ini-file in library-path)
	Sections copied successfully from ahk-rare:
				Done:::: add a double map to translate any assumed ahk_Version's to unified
				output: v1,v1.1,v2
	Idea:::: execute dependency-search in snippets when searching, and check if snippets covering those exist
		→ might be thrown out as too complex/ressource-heavy/pointless, just food for thought so far.

String/Array/Text
gui - interacting
Varius get
Clipboard
graphic
System functions/Binary handling
gui - get informations
Internet Explorer/Chrome/FireFox/HTML
Filesystem
Variables
Math/Converting
Internet/Network
gui - control type
Keys/Hotkeys/Hotstring
Objects
gui - customize
Hooks/Messaging
Font things
gui - menu
ACC (MSAA)
gui - to change
Other
ToolTips
Command CommandLine
System/User/hardware
Date or Time
gui - icon
UIAutomation
Other languages/MCode
gui - customise

*/
#NoEnv
#Persistent
#SingleInstance, Force
#InstallKeybdHook
#MaxThreads, 250
#MaxThreadsBuffer, On
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 1
ListLines Off

SetTitleMatchMode     	, 2
SetTitleMatchMode     	, Fast
DetectHiddenWindows	, Off
CoordMode                 	, Mouse, Screen
CoordMode                 	, Pixel, Screen
CoordMode                 	, ToolTip, Screen
CoordMode                 	, Caret, Screen
CoordMode                 	, Menu, Screen
SetKeyDelay                	, -1, -1
SetBatchLines           		, -1
SetWinDelay                	, -1
SetControlDelay          	, -1
SendMode                   	, Input
AutoTrim                     	, On
FileEncoding                	, UTF-8

; ttip("Comb through ahkrare-content and move example and description comment blocks to their respective files","add all metadata-fields to be used in the editor, and figure out how to do the editor metadata-adjustable")
; #Warn,,Off 

; some performance stuff

; #KeyHistory, 0
SetWorkingDir, %A_ScriptDir%
CodeTimer("")
CurrentMode:="Instr"
; Add scriptObj-template and convert Code to use it - maybe, just a thought. Syntax of the Library-File is probably way too special for doing so, and there are no real configs to save anyways
; separate library-files and settings-files, take a peek at ahk-rare to see what they store in settings

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
hi5 - tf - https://github.com/hi5/TF#ALG_TF_InsertPrefix
jballi - AddToolTip - https://www.autohotkey.com/boards/viewtopic.php?t=30079
G33kdude - RichCode - https://github.com/G33kDude/RichCode.ahk
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
                    ,doctext	  : "Documenation"
                    ,doclink	  : "https://github.com/Gewerd-Strauss/ScriptObj#readme"
                    ,forumtext	  : ""
                    ,forumlink	  : ""
                    ,donateLink	  : ""
                    ,resfolder    : A_ScriptDir "\res"
                    ,iconfile	  : A_ScriptDir "\res\sct.ico"
					,reqInternet  : false
					,rfile  	  : "https://github.com/Gewerd-Strauss/AHK-Code-Snippets/archive/refs/heads/Rework-Separated-Code-&-Metadata.zip"
					,vfile_raw	  : "https://raw.githubusercontent.com/Gewerd-Strauss/AHK-Code-Snippets/Speed-Test/version.ini" 
					,vfile 		  : "https://raw.githubusercontent.com/Gewerd-Strauss/AHK-Code-Snippets/Speed-Test/version.ini" 
					,vfile_local  : A_ScriptDir "\version.ini" 
                    ,ErrorCache	  :	[]
                    ,config		  :	[]
					,configfile   : A_ScriptDir "\INI-Files\" regexreplace(A_ScriptName, "\.\w+") ".ini"
                    ,configfolder : A_ScriptDir "\INI-Files"}

, f_CreateTrayMenu()
, script.Update(,,1)
, global bSearchSnippets:=false
FileGetVersion, Version, %A_ProgramFiles%\AutoHotkey\AutoHotkey.exe
; m(A_AhkVersion,Version)
FileDelete, % script.configfile ;; for testing purposes and keeping the settings updated when adding/changing keys
if !script.Load(,1) 
{ ;; default settings
	Map:={AU:"Author" ;; For fetching data from 'Matches', the presorted object 
		,DA:"Date"
		,Dep:"Dependencies"
		,Fi:"Library"
		,Ha:"Hash"
		,Key:"Keywords"
		,Li:"License"
		,Lic:"License"
		,Na:"Name"
		,Se:"Section"
		,Sec:"Section"
		,Url:"URL"
		,Ver:"Version"		}
	AHKVERSION:={AHK_Classic:"v1"
		,L:"v1.1"
		,v2:"v2"
		,H:"vH"} 
	script.config:={Settings:{Search_Code: false ;" " ";Check if you want to search code of snippets as well. Adds substantial overhead at bootup."
	, Search_Description:false
	, Search_Examples:false
	, Search_InString_MetaFields:true
	, DateFormat:"dd.MM.yyyy"
	, CopyDescriptionToOutput:true
	, CopyExampleToOutput:true
	, CopyMetadataToOutput:true
	, LibraryRelativeSI:false
	, ShowRedraw:false
	, bDebugSwitch:false
	, SoundAlertOnDebug:true
	, bSetSearchresultAlphabetically:true
	, Max_InDepth_Searchable:200
	, DirectoryPath:A_ScriptDir "\Sources"
	, bNotifyDependenciesOnCopy:false
	, bShowOnStartup:false}
	,Map2:Map,Search_Descriptions:{Search_Code:"Check if you want to search code of snippets as well. Adds substantial overhead at bootup."
    , Search_Description:"Check if you want to search descriptions of snippets as well. Adds substantial overhead at bootup."
	, Search_Examples:"Check if you want to search examples of snippets as well. Adds substantial overhead at bootup."
	, Search_InString_MetaFields:"Check if you want to search via In-String-matching in Metadata, instead of only allowing exact matches"
	, DateFormat:"Set the format with which to display dates."
	, CopyDescriptionToOutput:"Decide if you want to include the documentation when copying a snippet"
	, CopyExampleToOutput:"Decide if you want to include the example when copying a snippet"
	, CopyMetadataToOutput:"Decide if you want to include the metadata when copying a snippet"
	, LibraryRelativeSI:"TODO:NOT IMPLEMENTED:Set SnippetIdentifier relative to its own library"
	, ShowRedraw:"Display the redrawing of the LV-Control. Can reduce performance."
	, bDebugSwitch:"Set to true to expose additional information helpful for debugging issues."
	, SoundAlertOnDebug:"Set true/false if you want to get an audio-ping whenever entering/exiting debug mode. Recommended to be on as db-mode can alter how the program behaves."
	, Max_InDepth_Searchable:"Set the maximum number of snippets for which the script will also search all previously loaded Codes, Descriptions and Examples.`nFor more snippets, these searches will not be performed to not reduce performance too much."
	, DirectoryPath:"The path to search for snippets"
	, bNotifyDependenciesOnCopy:"Notify user of dependencies when notifying a snippet." ;; potentially only when the dependency also exists within?
	, bShowOnStartup:"Set whether or not to display the GUI on script startup or not."
	, Map2:"The Map corresponding shorthand searchkeys with their longhand assignments within the metadata"}}
	script.Save()
}
; script.Version:=script.config.Settings.ScriptVersion
global DirectoryPath:= ((substr(script.config.settings.DirectoryPath,-1)!="\*")?script.config.settings.DirectoryPath "\*":script.config.settings.DirectoryPath) ;"*" ;; this is the path that contains all libraries which will be read.
SnippetsStructure:=fLoadFolderLibraries(DirectoryPath)
Clipboard:=""
for k,v in SnippetsStructure[2]
	Clipboard.="`n" v
oArr:=SnippetsStructure.Clone()
SearchHistory:=[]

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


;;  an armada of different search testing strings :
; Clipboard:="Au:Gew Se:menu Li:Un"
; Clipboard:="Au:Gew Se:menu Li:Un Da:07.10.2022"
; Clipboard:="Fi:Libr AU:ano"
; Clipboard:="Au:Gew Se:menu Ver:1.3"
; ; Clipboard:="Au:Gew Se:menu"
; Clipboard:="fi:Sec"
; Clipboard:="au:gew fi:ary1"
; Clipboard:="Na:1 fi:ary1"
; clipboard:="Na:1 fi:ary1 au:ano"
; clipboard:="fi:sec au:ano"
; clipboard:="fi:sec au:ano NA:alib"
; clipboard:="gui - to change"
; clipboard:="getcommstate"
; clipboard:="InvokeVerb"
; clipboard:="PostMessageUn"
; clipboard:="controlgettabs"
; clipboard:="WinGetPosEx"
clipboard:="Ha:10550"
; Clipboard:="Au:anon na:1"
CodeTimer("AutoExec")
return



lGUICreate_1New: ;; Fully Parametric-form, TODO: functionalise this thing
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
					
					str:=Obj2Str(script.config.map2)
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
        			gui, add, edit, x%xPos_Edit_SearchMode% y%yPos_Edit_SearchMode% w%Width_Edit_SearchMode% r1 cBlack gfSuperviseSearchBar vSearchString HwndSearchStringHWND,  ; Search here
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
					gui, add, Link, y%yPos_DescriptionBox% x%xPos_DescriptionBox% w%Width_DescriptionBox% h%Height_DescriptionBox% vvEdit1, Edit1
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
			if script.config.settings.bShowOnStartup
				fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
			References:=fPrePopulateLV(SnippetsStructure)

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
		SB_SetParts(370,273,70,80,500)

		bIsAuthor:=(script.computername==script.authorID)
		bIsDebug:=script.config.settings.bDebugSwitch
		if (!bIsAuthor & !bIsDebug) || (bIsAuthor & !bIsDebug)
		{ ;; public display
			SB_SetText("Standard Mode Engaged. Click to enter debug-mode",2)
			ListLines, Off
			; KeyHistory
		}
		else if (!bIsAuthor && bIsDebug) || (bIsAuthor && bIsDebug)
		{
			SB_SetText("Author/Debug Mode Engaged. Click to exit debug-mode",2)
			ListLines, On
		}
		; f_SB_Set()
		SB_SetText("No Code from " script.name " on clipboard.", 1)
		if (SnippetsStructure[4,"ahk"]!=SnippetsStructure[4,"ini"]) 
			script.Error:="Critical Error: Metadata for " SnippetsStructure[4,"ini"] " files has been found, but code is present for " SnippetsStructure[4,"ahk"] " snippets."
		if (script.error!="")
			SB_SetText(script.error,5)
		else
			SB_SetText("Errors:/",5)
		SB_SetText("About this script",4)
		SB_SetText("NE:Settings",3)
		if script.config.settings.bShowOnStartup
			fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
        Hotkey, IfWinActive, % "ahk_id " MainGUI
		Hotkey, ^Tab,fTabThroughTabControl
        Hotkey, ^f, fFocusSearchBar
        Hotkey, ^s, fFocusSearchBar
        Hotkey, ^k, fFocusListView
        Hotkey, ^c, fCopyScript
		; Hotkey, ^r, lGuiCreate_2
		
			Obj_ExtraButton2:=Func("fEditSnippet").Bind(SnippetsStructure)
			Hotkey, !e, % Obj_ExtraButton2
			Obj_ResetListView:=Func("fResetListView").Bind(SnippetsStructure)
			Hotkey, Del, % Obj_ResetListView

        Hotkey, if, % SearchIsFocused
        		HotKey, ^BS, fDeleteWordFromSearchBar
        		Hotkey, ^k, fFocusListView
			Obj_SearchSnippets:=Func("fSearchSnippetsEnter").Bind(SnippetsStructure,References,DirectoryPath,SearchHistory)
			Obj_MoveThroughSearchHistory:=Func("fMoveThroughSearchHistory").Bind(SnippetsStructure,References,DirectoryPath,SearchHistory)
			Hotkey, ~Enter, % Obj_SearchSnippets
			Hotkey, ~Up, % Obj_MoveThroughSearchHistory
			Hotkey, ~Down, % Obj_MoveThroughSearchHistory
        Hotkey, if, % ListViewIsFocused
			Obj_MoveOnListView2:=Func("MoveOnListView").Bind(-1)
			Obj_MoveOnListView:=Func("MoveOnListView").Bind(1)

        ; Hotkey, ~Up, % Obj_MoveOnListView2
        ; Hotkey, ~Down, % Obj_MoveOnListView
		Obj_fLVCallback:=Func("fLV_Callback").Bind(SnippetsStructure,Matches)
        ; Hotkey, ~Up, fLV_Callback
        ; Hotkey, ~Down, fLV_Callback
        Hotkey, ~Up, % Obj_fLVCallback
        Hotkey, ~Down, % Obj_fLVCallback
        
        hotkey, if, % RCFieldIsClicked
        Hotkey, ~RButton, fCopyScript
        Hotkey, ~LButton, fCopyScript
		hotkey, if 
					; Gui, Color, 4f1f21, 432a2e
					; fFocusListView()
					; sleep, 300
		fSelectFirstLVEntry(SnippetsStructure,Matches)
		LastScaledSize:=[vGUIWidth,vGUIHeight]
		lCheckClipboardContents()
		if !script.config.settings.bShowOnStartup
			ttip(script.name " has finished initialisation.")
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
	return References
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
fSuperviseSearchBar()
{
	if Instr(fGetSearchFunctionsString(),"?")
		ttip(script.config.map2)
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
	fLV_Callback(SnippetObj,Matches)
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
		searchstr:=fGetSearchFunctionsString()
		SelectedLVEntry:=f_GetSelectedLVEntries()
		if (searchstr!="") && !Instr(Matches[1,SelectedLVEntry.3].Code,"Error 01: No code-file was found under the expected path")
			Code:=Matches[1,SelectedLVEntry.3].Code 
		else if !Instr(SnippetsStructure[1,SelectedLVEntry.3].Code,"Error 01: No code-file was found under the expected path")
			Code:=SnippetsStructure[1,SelectedLVEntry.3].Code 
		if (Code="") && (searchstr!="")
			fLoadFillDetails() ;(Matches,DirectoryPath)
		else if (Code="") && (searchstr="")
			fLoadFillDetails() ;(SnippetsStructure,DirectoryPath)
		if script.config.Settings.CopyMetadataToOutput
		{
			Author:=Data.Metadata.Author
			FormatTime, Date,% Data.Metadata.Date, % script.config.Settings.DateFormat
			License:=Data.Metadata.License
			Name:=Data.Metadata.Name
			Section:=Data.Metadata.Section
			URL:=Data.Metadata.URL
			Version:=Data.Metadata.Version
			SectionInd:=Data.Metadata.SectionInd
			Library:=Data.Metadata.Library
			KeyWords:=Data.Metadata.KeyWords
			AHK_Version:=(Data.Metadata.AHK_Version!=""?Data.Metadata.AHK_Version:"/")
			Dependencies:=(Data.Metadata.Dependencies!=""?Data.Metadata.Dependencies:"/")
			; Changelog:=Data.Metadata.Changelog ;; this one is a maybe because I would probably have to include an additional TAB+RC-Control cuz this would likely have to be its own file.
			; KeyWords:=Data.Metadata.KeyWords
			licenseURL:=Data.Metadata.licenseURL
			InfoText:=[]
			if (Name!="")
				InfoText.push("Snippet: " Name)
			if (Version!="")
				InfoText.push(" (v." Version ")`n")
			else
				InfoText[InfoText.MaxIndex()].="`n"
			InfoText.push("--------------------------------------------------------------`n")
			if (Author!="")
				InfoText.push("Author: " Author "`n")
			if (License!="")
			{
					InfoText.push("License: " License "`n")
				if (licenseURL!="")
					InfoText.Push("LicenseURL:  " LicenseURL "`n")
			}
			; else
			; {
			; 	if (License="")
			; 		InfoText.Push("`n")
			; }
			
			if (URL!="")
				InfoText.Push("Source: " URL "`n")
			if (Date!="") && (URL!="")
				InfoText.Push("(" Date ")`n")
			else if (URL!="")
				InfoText.Push("`n")
			if !Instr(InfoText[InfoText.MaxIndex()],"--------------------------------------------------------------") &&  !(Instr(InfoText[InfoText.MaxIndex()-1],"--------------------------------------------------------------") && InfoText[InfoText.MaxIndex()]="`n")
				InfoText.push("--------------------------------------------------------------`n")
			InfoText.push("Library: "Library "`n")
			InfoText.push("Section: "SectionInd " - " Section "`n")
			if (Dependencies!="")
				InfoText.push("Dependencies: " Dependencies "`n")
			if (AHK_Version!="")
				InfoText.push("AHK_Version: " AHK_Version "`n")
			if !Instr(InfoText[InfoText.MaxIndex()],"--------------------------------------------------------------") &&  !(Instr(InfoText[InfoText.MaxIndex()-1],"--------------------------------------------------------------") && InfoText[InfoText.MaxIndex()]="`n")
				InfoText.push("--------------------------------------------------------------`n")
			if (KeyWords!="")
				InfoText.push("Keywords: " Keywords)
			FinalInfoText:=""
			for k,v in InfoText
				FinalInfoText.="; " v
			Code:=PrependTextBeforeString(Code,"; Metadata:`n" FinalInfoText)
		}
		if script.config.Settings.CopyExampleToOutput
		{
			if (searchstr!="") && !Instr(Matches[1,SelectedLVEntry.3].Example,"Error 01: No example-file was found under the expected path")
				Example:=ALG_TF_InsertPrefix(Matches[1,SelectedLVEntry.3].Example,1,, ";; ") ;; make sure the example is definitely a comment 
			else if !Instr(SnippetsStructure[1,SelectedLVEntry.3].Example,"Error 01: No example-file was found under the expected path")
				Example:=ALG_TF_InsertPrefix(SnippetsStructure[1,SelectedLVEntry.3].Example,1,, ";; ") ;; make sure the example is definitely a comment 
			if (Example!="") && !Instr(Example, "Error 01: No example-file was found under the expected path") ;; make sure the contents are not appended if they are already loaded but still contain the error-string
				Code:=PrependTextBeforeString(Code,";; Example:`n" Example)
		}
		else
		{
			if (searchstr!="") && !Instr(Matches[1,SelectedLVEntry.3].Example,"Error 01: No example-file was found under the expected path")
				Example:=ALG_TF_InsertPrefix(Matches[1,SelectedLVEntry.3].Example,1,, ";; ") ;; make sure the example is definitely a comment 
			else if !Instr(SnippetsStructure[1,SelectedLVEntry.3].Example,"Error 01: No example-file was found under the expected path")
				Example:=ALG_TF_InsertPrefix(SnippetsStructure[1,SelectedLVEntry.3].Example,1,, ";; ") ;; make sure the example is definitely a comment 
			if (Example!="") && !Instr(Example, "Error 01: No example-file was found under the expected path") 
				Code:=SnippetsStructure[1,SelectedLVEntry.3].Code
		}
		if script.config.Settings.CopyDescriptionToOutput
		{
			if (searchstr!="") && !Instr(Matches[1,SelectedLVEntry.3].Description,"Error 01: No description-file was found under the expected path")
				Description:=ALG_TF_InsertPrefix(Matches[1,SelectedLVEntry.3].Description,1,, ";;; ") ;; make sure the example is definitely a comment 
			else if !Instr(SnippetsStructure[1,SelectedLVEntry.3].Description,"Error 01: No description-file was found under the expected path")
				Description:=ALG_TF_InsertPrefix(SnippetsStructure[1,SelectedLVEntry.3].Description,1,, ";;; ") ;; make sure the example is definitely a comment 
			if (Description!="") && !Instr(Description,"Error 01: No description-file was found under the expected path")
				Code:=PrependTextBeforeString(Code,";;; Description:`n" Description)
		}
		else
		{
			if (searchstr!="") && !Instr(Matches[1,SelectedLVEntry.3].Description,"Error 01: No description-file was found under the expected path")
				Description:=ALG_TF_InsertPrefix(Matches[1,SelectedLVEntry.3].Description,1,, ";;; ") ;; make sure the example is definitely a comment 
			else if !Instr(Matches[1,SelectedLVEntry.3].Description,"Error 01: No description-file was found under the expected path")
				Description:=ALG_TF_InsertPrefix(SnippetsStructure[1,SelectedLVEntry.3].Description,1,, ";;; ") ;; make sure the example is definitely a comment 
			if (Description!="") && !Instr(Description,"Error 01: No description-file was found under the expected path")	
				Code:=SnippetsStructure[1,SelectedLVEntry.3].Code
		}
		Code:=ALG_st_Insert(";--uID:" SnippetsStructure[1,SelectedLVEntry.3].Metadata.Hash "`n",Code) . "`n" ;; prepend uID-token
		Code:=ALG_st_Insert(";--uID:" SnippetsStructure[1,SelectedLVEntry.3].Metadata.Hash "`n",Code,StrLen(Code)+StrLen(";--uID:" SnippetsStructure[1,SelectedLVEntry.3].Metadata.Hash "`n")) ;; append uID-token
		Clipboard:=Code
		nameStr:=SnippetsStructure[1,SelectedLVEntry.3,"MetaData","Name"]
		; nameStr:="abcdefghijklmnopqrstuvwxyz1234567890"
		Str:="On Clipboard: " SubStr(nameStr,1,20) (SnippetsStructure[1,SelectedLVEntry.3,"MetaData","Version"]!=""?" (v." SnippetsStructure[1,SelectedLVEntry.3,"MetaData","Version"] ")":"")
		SB_SetText(Str , 1)

	}
	return
}
PrependTextBeforeString(Text,StringToInsert)
{ ;; adds 'StringToInsert' two lines before 'Text' and returns the result
	return StringToInsert "`n`n" Text
}

FileCount(filter, mode)
{ ;-- count matching files in the working directory

   loop,files,% filter,% mode
     Count := A_Index
   return Count

} ;</07.01.000017>
lIngestSnippet:
{
	EditorImporter("Ingestion",SnippetsStructure)
}
return
lEditSnippet: ;; I have no idea how to bind a function to a gui-button itself.
{
	fEditSnippet(SnippetsStructure)
}
return
fEditSnippet(SnippetsStructure:="")
{
	gui,1: submit, NoHide
	SelectedLVEntry:=f_GetSelectedLVEntries()
	SearchStr:=fGetSearchFunctionsString()
	fLoadFillDetails() ;(SnippetsStructure,DirectoryPath)
	EditorImporter(SnippetsStructure[1,SelectedLVEntry.3] ,SnippetsStructure)
	return
}

fCallBack_StatusBarMainWindow(Path:="")
{
	; not implemented yet
	gui, submit, NoHide
	if ((A_GuiEvent="DoubleClick") && (A_EventInfo=5)) || (Path=5) ;; trigger Error
		SB_SetText("Testing Error", 2)
	if (((A_GuiEvent="DoubleClick") && (A_EventInfo=4))) || (Path=1) ;; trigger About
		script.About()
	if ((A_GuiEvent="DoubleClick") && (A_EventInfo=3)) || (Path=5) ;; trigger update
	{
		;; TODO: write update-routine for data-only into scriptobj.
	}
	if ((A_GuiEvent="DoubleClick") && (A_EventInfo=2)) || (Path=2) ;; toggle debug mode
	{
		script.config.settings.bDebugSwitch:= !script.config.settings.bDebugSwitch
		bIsAuthor:=(script.computername==script.authorID)
		bIsDebug:=script.config.settings.bDebugSwitch
		if (!bIsAuthor & !bIsDebug) || (bIsAuthor & !bIsDebug)
		{ ;; public display
			if script.config.settings.SoundAlertOnDebug
			{
				SoundBeep, 150, 150
				SoundBeep, 150, 150
				SoundBeep, 150, 150
				SB_SetText("Standard Mode Engaged. Click to enter debug-mode",2)
				
			}
		}
		else if (!bIsAuthor & bIsDebug) || (bIsAuthor & bIsDebug)
		{
			if script.config.settings.SoundAlertOnDebug
			{
				SoundBeep, 1750, 150
				SoundBeep, 1750, 150
				SoundBeep, 1750, 150
			}
			SB_SetText("Author/Debug Mode Engaged. Click to exit debug-mode",2)
		}
		if !strsplit(script.config.settings.ShowRedraw,A_Space).1
			GuiControl, -Redraw, LVvalue
		if strsplit(script.config.settings.ShowRedraw,A_Space).1
			GuiControl, +Redraw, LVvalue
		f_RescaleLV()
		GuiControl, +Redraw, LVvalue
		StatusBarGetText, currText, 2, % GuiNameMain
		if (currText!="no Error")
			if script.error
				script.Debug(script.error.Level,script.error.Label,script.error.Message,script.error.AddInfo,script.error.Vars)
	}
	return
}
fLV_Callback(SnippetsStructure,FoundMatches)
{ ;; decides based on contents of searchbox what contents to load into the richfields and edit-fields
	global ;; there is certainly a way to avoid this global here, but for me it is far too complicated.
	str:=fGetSearchFunctionsString()
	if (str="") ;; search-box is empty, thus we ingest the default Object
		func := Func("fLoadFillDetails") ;.Bind(SnippetsStructure,DirectoryPath) ;; need to remember how to do this
	else 		;; search-box is not empty, thus we ingest the search results
		func := Func("fLoadFillDetails") ;.Bind(Matches,DirectoryPath) ;; need to remember how to do this
	Settimer, % func, Off
	Settimer, % func, -150 ;; TODO: replace this timer with the hook proposed by anonymous1184
	return
}
; SnippetsStructure
fLoadFillDetails()
{ ;; Load the details into the Details-Field and load Code, Example and Description
	global
	gui,1: default
	gui,1: submit, NoHide
	if (A_GuiControlEvent="ColClick")
		return
	SelectedLVEntry:=f_GetSelectedLVEntries()
	if (SelectedLVEntry="") && (A_ThisLabel!="lSearchSnippets") 
		SelectedLVEntry:=[,,1]
	Data:=SnippetsStructure[1,SelectedLVEntry[3]] 
	Path:=SubStr(DirectoryPath,1,StrLen(DirectoryPath)-1) Data["Metadata","Library"] "\" Data["MetaData","Hash"] ;SelectedLVEntry[1,1].Library "\" SelectedLVEntry[1,1].Hash
	,Code:= Data.Code ;SnippetStructure[1,SelectedLVEntry[3]].Code
	,Description:=Data.Description ;SnippetsStructure[1,SelectedLVEntry[3]].Description
	,Example:=Data.Example ;SnippetsStructure[1,SelectedLVEntry[3]].Example

	
	if (Data="")	
		return
	if (Code="") || Instr(Code,"Error 01: File '")
	{
		bIsAuthor:=(script.computername==script.authorID)
		bIsDebug:=script.config.settings.bDebugSwitch
		if FileExist(Path ".ahk")
		{
			FileRead, Code, % Path ".ahk"
			if (Code!="")
				LoadedCount:=(LoadedCount=""?1:LoadedCount+1)
			if (!bIsAuthor && bIsDebug) || (bIsAuthor && bIsDebug)
			{
				MessageString:="DB - Codes Loaded: " fPadIndex(LoadedCount,SnippetsStructure[5]) "/" SnippetsStructure[5]  ":Last: " Data["Metadata"].Name
				SB_SetText(MessageString,6) 
			}
			else
			{
				MessageString:="S:" fPadIndex(LoadedCount,SnippetsStructure[5]) "/" SnippetsStructure[5] ;", L:" SnippetsStructure[3]
				SB_SetText(MessageString,6) 
			}

		}
		else
		{
			str:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"])
			if FileExist(str:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"]) ".ahk")  ;; in case the file does not exist, try with the name set within the metadata.
			{
				Path:=strreplace(Path,Data["Metadata","Hash"],Data["Metadata","Name"])
				FileRead, Code, % Path ".ahk"
			}
			else
				Code:="Error 01: No code-file was found under the expected path '" Path ".ahk'.`nCode could not be loaded.`nEither ignore or add Code-file and reload."
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
				Description:="Error 01: No description-file was found under the expected path '" Path ".example'.`nDescription could not be loaded.`nEither ignore or add description-file and reload."
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
				Example:="Error 01: No example-file was found under the expected path '" Path ".example'.`nExample could not be loaded.`nEither ignore or add example-file and reload."
		}
		; 	Code:="Error 01: File '" Path ".example does not exist.`nCode could not be loaded.`nPlease Reload the script after fixing the issue."

		; else
		SnippetsStructure[1,SelectedLVEntry[3]].Example:=Example
	}
	Author:=Data.Metadata.Author
	FormatTime, Date,% Data.Metadata.Date, % script.config.Settings.DateFormat
	; Hash
	License:=Data.Metadata.License
	Name:=Data.Metadata.Name
	Section:=Data.Metadata.Section
	URL:=Data.Metadata.URL
	Version:=Data.Metadata.Version
	SectionInd:=Data.Metadata.SectionInd
	Library:=Data.Metadata.Library
	KeyWords:=Data.Metadata.KeyWords
	AHK_Version:=(Data.Metadata.AHK_Version!=""?Data.Metadata.AHK_Version:"/")
	Dependencies:=(Data.Metadata.Dependencies!=""?Data.Metadata.Dependencies:"/")
	; Changelog:=Data.Metadata.Changelog ;; this one is a maybe because I would probably have to include an additional TAB+RC-Control cuz this would likely have to be its own file.
	; KeyWords:=Data.Metadata.KeyWords
	licenseURL:=Data.Metadata.licenseURL
	InfoText:=[]
	if (Name!="")
		InfoText.push("Snippet: " Name)
	if (Version!="")
		InfoText.push(" (v." Version ")`n")
	else
		InfoText[InfoText.MaxIndex()].="`n"
	InfoText.push("--------------------------------------------------------------`n")
	if (Author!="")
		InfoText.push("Author: " Author "`n")
	if (License!="")
	{
		if (licenseURL="")
			InfoText.push("License: " License "`n")
	}
	if (licenseURL!="")
		InfoText.Push("License: <a href=""" LicenseURL """>" (License=""?"License":License) "</a>`n")
	; else
	; {
	; 	if (License="")
	; 		InfoText.Push("`n")
	; }
	
	if (URL!="")
		InfoText.Push("<a href=""" URL """>Source</a> ")
	if (Date!="") && (URL!="")
		InfoText.Push("(" Date ")`n")
	else if (URL!="")
		InfoText.Push("`n")
	if !Instr(InfoText[InfoText.MaxIndex()],"--------------------------------------------------------------") &&  !(Instr(InfoText[InfoText.MaxIndex()-1],"--------------------------------------------------------------") && InfoText[InfoText.MaxIndex()]="`n")
		InfoText.push("--------------------------------------------------------------`n")
	InfoText.push("Library: "Library "`n")
	InfoText.push("Section: "SectionInd " - " Section "`n")
	if (Dependencies!="")
		InfoText.push("Dependencies: " Dependencies "`n")
	if (AHK_Version!="")
		InfoText.push("AHK_Version: " AHK_Version "`n")
	if !Instr(InfoText[InfoText.MaxIndex()],"--------------------------------------------------------------") &&  !(Instr(InfoText[InfoText.MaxIndex()-1],"--------------------------------------------------------------") && InfoText[InfoText.MaxIndex()]="`n")
		InfoText.push("--------------------------------------------------------------`n")
	if (KeyWords!="")
		InfoText.push("Keywords: " Keywords)
	FinalInfoText:=""
	for k,v in InfoText
		FinalInfoText.=v

	guicontrol,1:, vEdit1,% FinalInfoText
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
	lOpenScriptFolder:
	run, % A_ScriptDir
	return
	lReload: 
	reload
	return
	Label_AboutFile:
	script.about()
	return
}

lCheckClipboardContents()
{ ;; todo: check clipboard-contents for contents
	gui, 1: Submit, NoHide
	return
}
fMoveThroughSearchHistory(SnippetsStructure,References,DirectoryPath,SearchHistory)
{
	SearchString:=fGetSearchFunctionsString()

	OldPos:=Pos:=HasVal(SearchHistory,SearchString)+0
	Pos:=(Pos=0?SearchHistory.MaxIndex():Pos)
	Dir:=(Instr(A_ThisHotkey,"Up")?-1:1)
	; if Instr(A_ThisHotkey,"Up")
	; 	Dir:=-1
	; else
	; 	Dir:=1
	Pos:=Pos+Dir + (SearchString=""?1:0) ;; adjustment if search is empty and we want to find the latest search result
	Pos:=(Pos<1?1:Pos)
	if (Pos=OldPos) ;; reached start/end of search history, no need to refresh the LV
		return
	NewSearchString:=SearchHistory[Pos]
	fSetSearchFunctionsString(NewSearchString,SearchString)
	ttip(Pos)
	if (NewSearchString="")
	{
		fResetListView(SnippetsStructure)		
		fFocusListView()
	}
	fSearchSnippetsEnter(SnippetsStructure,References,DirectoryPath,SearchHistory)
	return
}
fSearchSnippetsEnter(SnippetsStructure,References,DirectoryPath,SearchHistory)
{
	; A_GuiControl A_ThisHotkey A_ThisFunc A_THisLabel A_GuiControlEvent A_GuiEvent | always useful having these here when checking annoying states
	lSearchSnippets:
		; Settimer, % func, Off
		Gui, 1: Submit, NoHide
		; GuiControlGet, currentSearch, , SearchString
		SearchString:=fGetSearchFunctionsString()
		; Matches:=[] ;; create Obj
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
			; A_ThisHotkey
			fLoadFillDetails() ;(Matches,DirectoryPath)
			
			f_RescaleLV(1,script.config.Settings.bSetSearchresultAlphabetically)
			global bSearchSnippets:=false
			if (A_ThisHotkey!="~Up") && (A_ThisHotkey!="~Down")
			{
				fSelectFirstLVEntry_Searches()
				sleep,200
				; Matches:=[]
				SendInput, % "{Up}"
			}
		}
		if (Matches=-1)
			ttip("No results")
		if (SearchString!="") && !HasVal(SearchHistory,SearchString) && (Matches[1]!=-1)
			SearchHistory.push(SearchString)
	return SearchHistory

}

fGetSearchFunctionsString()
{ ;; retrieves the contents of the search-edit field
	GuiControlGet, ContentsSearchField,,SearchString
	return ContentsSearchField
}
fSetSearchFunctionsString(Str,OldStr)
{ ;; sets the contents of the search-edit field
	GuiControl, , SearchString, % Str
	Result:=(fGetSearchFunctionsString()!=""?true:false) 
	return Result
}

fSelectFirstLVEntry_Searches()
{ ;; selects the visually first element currently on the listview
	SendInput, {Down}{Up}
	return
}

; MoveOnListView(Direction:=1)
; { 
; 	sleep, 150
; 	SendInput, % str:="{" ((Direction==1)?"Down":"Up") "}"
; 	return
; }

fSelectFirstLVEntry(SnippetsStructure,Matches)
{ ;; selects the first entry of the listview, but then also initiates the population of the richfields and edit-field9
	fSelectFirstLVEntry_Searches()
	fLV_Callback(SnippetsStructure,Matches)
	return
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

#If WinActive(GuiNameMain)
^T::fCallBack_StatusBarMainWindow(2)
Esc::fGuiHide_1()
Numpad9:: ;; resizes the GUI 
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
fGuiShow_1(vGUIWidth,vGUIHeight,GuiNameMain)
return

; #if Winactive(GuiNameIngestion)
; Esc::
; gui, 2: destroy
; gui, 1: show
; return
#If (A_ComputerName=script.AuthorID?1:0) 
!esc::
SendInput, ^s  
reload
return ; yes I know this is not actually needed. I don't care.

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
	,Sec:2
	,Li:3
	,Da:4
	,Fi:5}
	regex:="("
	for k,v in script.config.map2
		regex.=k "|"
	regex:=SubStr(regex,1,StrLen(regex)-1) "):(.+?)`n"

	str:=""
	pos := 1
	
	     
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
	for k,v in script.config.map2
	{
		String:=TRIM(strreplace(String,k ":","`n" k ":"))
	}

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
				if RegexMatch(v,"\d+")
				{
					if Instr(s,AllSections[v])
						str.=", " w
				}
				else if Instr(s,v)
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
	
	
	if (Matches.Count()=0)
		Matches:=Array.Clone()

	if (Matches.Count()=Array.Count())
	{
		Threshold:=KeyVals.Count()
		for s,w in Matches
		{
			MatchCount:=0
			for k,v in KeyVals
			{
				SearchedStr:=Matches[s,"MetaData",script.config.map2[k]]
				Needle:=(k="DA")?DateParse(v):v
				if script.config.settings.Search_InString_MetaFields
				{
					if InStr(SearchedStr,needle)
					{
						MatchCount++
						; Matches2.push(w) ;; moved below into matchcount-check
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
				; if MatchCount=Threshold
				; {
				; 	; yes I need a catcher here 
				; }
			}
			if (MatchCount=Threshold)
			{
				if !Instr(AddedOnes,w.Metadata.Hash)
					Matches2.push(w)
				MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
				AddedOnes.=w.Metadata.Hash ", " ;; repeats here is not a problem, the string is only checked with instr anyways. 
			}
		}
	}
	else
	{
		for k,v in KeyVals  ;; and finally, remove the faultily-added entry which does not conform in LI
		{
			if Instr("AU,SEC",k) ;; pre-handled already
			{
				for s,w in Matches
				{
					if !Instr(AddedOnes,w.Metadata.Hash)
						Matches2.push(w)
					MatchedLibraries[Matches[s,"Metadata","Library"]]:=1
					AddedOnes.=w.Metadata.Hash ", "
					if Instr(w.Metadata[script.config.map2[k]],v)
					{

					}
					else
					{

					}
				}
				continue
			}
			
			for s,w in Matches
			{
				; if instr(w.Metadata.Library,"second")
				; 	{
					;; Catcher for quicker testing	
				; 	}
				SearchedStr:=Matches[s,"MetaData",script.config.map2[k]]
				Needle:=(k="DA")?DateParse(v):(Instr(k,"Se")?AllSections[v]:v)
				; if Instr(k,"Se")
				; 	Needle:=AllSections[v]
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
	if (Matches.Count()=Array.Count()) && (Matches2.Count()="")
		Matches2:=Matches.Clone()
	for s,w in Matches2
	{
		for x,y in KeyVals
		{
			Needle:=(x="DA")?DateParse(y):(Instr(x,"Se")?AllSections[y]:y)
			PassedVal:=w.Metadata[script.config.map2[x]]
			; if !Instr(PassedVal,y)
			if !Instr(PassedVal,Needle)
				Matches2.Delete(s)
		}
	}
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
GetFocusedControl()  {                                                                                            	;-- retrieves the ahk_id (HWND) of the active window's focused control.

        ; This script requires Windows 98+ or NT 4.0 SP3+.
        /*
        typedef struct tagGUITHREADINFO {
        DWORD cbSize;
        DWORD flags;
        HWND  hwndActive;
        HWND  hwndFocus;
        HWND  hwndCapture;
        HWND  hwndMenuOwner;
        HWND  hwndMoveSize;
        HWND  hwndCaret;
        RECT  rcCaret;
        } GUITHREADINFO, *PGUITHREADINFO;
        */

    guiThreadInfoSize := 8 + 6 * A_PtrSize + 16
   VarSetCapacity(guiThreadInfo, guiThreadInfoSize, 0)
   NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
   ; DllCall("RtlFillMemory" , "PTR", &guiThreadInfo, "UInt", 1 , "UChar", guiThreadInfoSize)   ; Below 0xFF, one call only is needed
   if (DllCall("GetGUIThreadInfo" , "UInt", 0   ; Foreground thread
         , "PTR", &guiThreadInfo) = 0)
   {
      ErrorLevel := A_LastError   ; Failure
      Return 0
   }
   focusedHwnd := NumGet(guiThreadInfo,8+A_PtrSize, "Ptr") ; *(addr + 12) + (*(addr + 13) << 8) +  (*(addr + 14) << 16) + (*(addr + 15) << 24)

	Return focusedHwnd
} ;</06.04.02.000002>

f_GetSelectedLVEntries(Number:="")
{ ; Get Values from selected row in LV A_DefaultListView ;TODO: this can probably be condensed
    vRowNum:=0
	, sel:=[]
	if (Number="")
	{
		loop 
		{
			CurrFocusName:=""
			CurrFocus:=GetFocusedControl()
			GuiControlGet, CurrFocusName, 1:Name,%CurrFocus%
			if (CurrFocusName!="LVvalue")
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
			CurrFocusName:=""
			CurrFocus:=GetFocusedControl()
			GuiControlGet, CurrFocusName, 1:Name,%CurrFocus%
			if ((CurrFocusName!="SearchString") && (A_ThisHotkey!="~Up") && (A_ThisHotkey!="~Down"))
				fFocusListView()
			return [sel,vRowNum,sCurrText6]
		}
	}
	; Else
	; {
	; 	loop
	; 	{
	; 		vRowNum:=LV_GetNext(vRowNum)
	; 			; if not vRowNum  ; The above returned zero, so there are no more selected rows.
	; 				break
	; 	}
	; 		LV_GetText(sCurrText1,Number,1) ; SectionInd - SectionName
	; 		LV_GetText(sCurrText2,Number,2) ; Name
	; 		LV_GetText(sCurrText3,Number,3) ; Hash
	; 		LV_GetText(sCurrText4,Number,4) ; LibraryName
	; 		LV_GetText(sCurrText5,Number,5) ; LVIdentifier
	; 		LV_GetText(sCurrText6,Number,6) ; AdditionIndex

	; 		LV_GetText(sCurrText7,Number,7) ; License
	; 		LV_GetText(sCurrText8,Number,8) ; Version
	; 		LV_GetText(sCurrText9,Number,9) ; Author
	; 		sel[(vRowNum=0?1:vRowNum)]:={SelectedEntrySection:sCurrText1
	; 		,SelectedEntryName:sCurrText2
	; 		,Hash:sCurrText3
	; 		,Library:sCurrText4
	; 		,SelectedEntrySnippetIdentifier:sCurrText5
	; 		,AdditionIndex:sCurrText6
	; 		,License:sCurrText7
	; 		,Version:sCurrText8
	; 		,Author:sCurrText9}
	; 		return [sel,(vRowNum=0?1:vRowNum),sCurrText6]

	; }
	; loop
	; {

	; 	vRowNum:=LV_GetNext(vRowNum)
	; 			if not vRowNum  ; The above returned zero, so there are no more selected rows.
	; 				break
	; }
	vRowNum:=(vRowNum=0?1:vRowNum)
			LV_GetText(sCurrText1,vRowNum,1) ; SectionInd - SectionName
			LV_GetText(sCurrText2,vRowNum,2) ; Name
			LV_GetText(sCurrText3,vRowNum,3) ; Hash
			LV_GetText(sCurrText4,vRowNum,4) ; LibraryName
			LV_GetText(sCurrText5,vRowNum,5) ; LVIdentifier
			LV_GetText(sCurrText6,vRowNum,6) ; AdditionIndex

			LV_GetText(sCurrText7,vRowNum,7) ; License
			LV_GetText(sCurrText8,vRowNum,8) ; Version
			LV_GetText(sCurrText9,vRowNum,9) ; Author
			sel[(vRowNum=0?1:vRowNum)]:={SelectedEntrySection:sCurrText1
			,SelectedEntryName:sCurrText2
			,Hash:sCurrText3
			,Library:sCurrText4
			,SelectedEntrySnippetIdentifier:sCurrText5
			,AdditionIndex:sCurrText6
			,License:sCurrText7
			,Version:sCurrText8
			,Author:sCurrText9}

	CurrFocus:=GetFocusedControl()
	GuiControlGet, CurrFocusName, 1:Name,%CurrFocus%
	if ((CurrFocusName!="SearchString") && (A_ThisHotkey!="~Up") && (A_ThisHotkey!="~Down"))
		fFocusListView()
	else
		fFocusSearchBar()
	return [sel,(vRowNum=0?1:vRowNum),sCurrText6]
}

fPopulateLVNew(Snippets,SectionNames,LibraryCount)
{
    LV_Delete()
	SectionPad:=(SectionPad!=""?SectionPad:"") ;; this is fucking painful that I can't just have a variable be _static_ so I only actually have to declare it once. _ugh_
	, NewSnippetsSorted:=[]
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
				, v.MetaData.SectionInd:=fPadIndex(SectionNamesReversed[v.Metadata.Section],SectionNames.Count())
				; ; TempInd:=SectionNamesRespectiveIndex[v.Metadata.Section]++
				; Clipboard:=SectionNamesRespectiveIndex[v.Metadata.Section]	
		}
		Addition:=[] ;; remove all of these and move them into the LV_Add instead, then comment this one out as a help for understanding later
		, Addition.LVSection:=(fPadIndex(v.MetaData.SectionInd,SectionPad)) " - " (strlen(v.MetaData.Section)<=0?"-1 INVALIDSECTIONKEY":v.MetaData.Section)
		, Addition.Name:=v.MetaData.Name
		, Addition.Hash:=v.MetaData.Hash
		, Addition.LibraryName:=v.MetaData.Library
		, Addition.LVIdentifier:=fPadIndex(v.MetaData.SectionInd,SectionPad) "." fPadIndex((InStr(A_ThisLabel,"lSearchSnippets")?v.MetaData.LVInd:v.MetaData.LVInd),SectionPad)
		, Addition.License:=strreplace(v.Metadata.License,"none","/")
		, Addition.Version:=v.Metadata.Version
		, Addition.Author:=SubStr(v.Metadata.Author,1,150)
		if Instr(A_ThisLabel,"GuiCreate_1New")
		{
			v.MetaData.AdditionIndex:=fPadIndex(k,Snippets.Count())
		}
		Addition.AdditionIndex:=v.MetaData.AdditionIndex
		LV_Add("-E0x200"
		, Addition.LVSection
		, Addition.Name
		, Addition.Hash
		, Addition.LibraryName
		, Addition.LVIdentifier
		, Addition.AdditionIndex
		, Addition.License
		, Addition.Version
		, Addition.Author
		, Addition.LVIdentifier                 )
	}
	; m(d,Snippets.Count())
	guicontrol,,vSearchFunctions,% Snippets.count() " snippets loaded from " LibraryCount  ((LibraryCount>1)?" libraries":" library")
	sleep, 300
	return [AuthorReferences,SectionReferences,LicenseReferences,DateReferences,FileReferences]
}

f_RescaleLV(OverWriteShow:=false,SearchResultSort:=false)
{ ;; makes sure the ListView is correctly scaled. 
	bIsAuthor:=(script.computername==script.authorID)
	bIsDebug:=script.config.settings.bDebugSwitch
	if   (!bIsAuthor & !bIsDebug) || (bIsAuthor & !bIsDebug)
	{
		LV_ModifyCol(5,0)
		, LV_ModifyCol(3,0)
		, LV_ModifyCol(6,0) 
		, LV_ModifyCol(7,"AutoHdr") 
		, LV_ModifyCol(8,"AutoHdr") 
		, LV_ModifyCol(9,"AutoHdr") 
	}
	if (!bIsAuthor && bIsDebug) || (bIsAuthor && bIsDebug) || OverWriteShow
	{
		LV_ModifyCol(5,"AutoHdr")
		, LV_ModifyCol(3,"AutoHdr") 
		, LV_ModifyCol(6,"AutoHdr") 
		, LV_ModifyCol(7,"AutoHdr") 
		, LV_ModifyCol(9,"AutoHdr") 
		, LV_ModifyCol(8,"AutoHdr") 
    	; , LV_ModifyCol(10,"Left")
	}
	if !SearchResultSort
		LV_ModifyCol(10,"Sort")
	else
		LV_ModifyCol(2,"Sort")
    LV_ModifyCol(1,"AutoHdr")
    , LV_ModifyCol(2,"AutoHDr")
	, LV_ModifyCol(4,"AutoHdr")
	, LV_ModifyCol(4,"Right")
	, LV_ModifyCol(10,"AutoHdr")
    , LV_ModifyCol(10,"Right")
	; if !SearchResultSort
	; 	LV_ModifyCol(10,"Sort")
	; else
	; 	LV_ModifyCol(2,"Sort")
	; , LV_ModifyCol(9,"AutoHdr")
	; , LV_ModifyCol(10,"AutoHdr")
	; , LV_ModifyCol(10,"Left")

}

f_FillFields(Code,Description,Example)
{ ;; inserts Code/Desc/Ex into the respective RichField-Controls
 	RC.Settings.Highlighter := "HighlightAHK"
	, RC.Value := []
	, RC.Value:=code
	, RC2.Value:=Example
	, RC3.Value:=Description
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
}

floadFolderLibraries(DirectoryPath)
{	;; new method of loading snippets by separating data and 
	
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
		Err:=0
		if !FileExist(DirName "\" NameNExt ".ahk") ; && !FileExist(DirName "\" NameNExt ".description") && !FileExist(DirName "\" NameNExt ".example")
		{
			Err++
		}
		if !FileExist(DirName "\" NameNExt ".ini") ; && !FileExist(DirName "\" NameNExt ".description") && !FileExist(DirName "\" NameNExt ".example")
		{
			Err++

		}
		if !FileExist(DirName "\" NameNExt ".example")
		{
			Err++
			
		}
		if !FileExist(DirName "\" NameNExt ".description")
		{
			Err++

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
	return [Arr,SectionNames,LibrariesKnown.Count(),FileTypeCount,Arr.Count()]
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

CodeTimer(Description,x:=500,y:=500,ClipboardFlag:=0)
{ ; adapted from https://www.autohotkey.com/boards/viewtopic.php?t=45263
	
	Global StartTimer
	
	If (StartTimer != "")
	{
		FinishTimer := A_TickCount
		TimedDuration := FinishTimer - StartTimer
		StartTimer := ""
		If (ClipboardFlag=1)
		{
			Clipboard:=TimedDuration
		}
		tooltip, Timer %Description%`n%TimedDuration% ms have elapsed!, x,y
		Settimer, lRemoveCodeTimer, -5000
		Return TimedDuration
	}
	Else
		StartTimer := A_TickCount
	Return
	lRemoveCodeTimer:
	tooltip,
	return
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
	static timercount
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
	sleep, % (mod(timercount,2)?to2:to)
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

ALG_TF_InsertPrefix(Text, StartLine = 1, EndLine = 0, InsertText = "")
	{
	 ALG_TF_GetData(OW, Text, FileName)
	 ALG_TF_MatchList:=ALG_TF__MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %ALG_TF_MatchList%
			OutPut .= InsertText A_LoopField "`n"
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return ALG_TF_ReturnOutPut(OW, OutPut, FileName)
	}

ALG_TF_GetData(byref OW, byref Text, byref FileName)
	{
	 If (text = 0 "") ; v3.6 -> v3.7 https://github.com/hi5/TF/issues/4 and https://autohotkey.com/boards/viewtopic.php?p=142166#p142166 in case user passes on zero/zeros ("0000") as text - will error out when passing on one 0 and there is no file with that name
		{
		 IfNotExist, %Text% ; additional check to see if a file 0 exists
			{
			 MsgBox, 48, TF Lib Error, % "Read Error - possible reasons (see documentation):`n- Perhaps you used !""file.txt"" vs ""!file.txt""`n- A single zero (0) was passed on to a TF function as text"
			 ExitApp
			}
		}
	 OW=0 ; default setting: asume it is a file and create file_copy
	 IfNotInString, Text, `n ; it can be a file as the Text doesn't contact a newline character
		{
		 If (SubStr(Text,1,1)="!") ; first we check for "overwrite"
			{
			 Text:=SubStr(Text,2)
			 OW=1 ; overwrite file (if it is a file)
			}
		 IfNotExist, %Text% ; now we can check if the file exists, it doesn't so it is a var
			{
			 If (OW=1) ; the variable started with a ! so we need to put it back because it is variable/text not a file
				Text:= "!" . Text
			 OW=2 ; no file, so it is a var or Text passed on directly to TF
			}
		}
	 Else ; there is a newline character in Text so it has to be a variable
		{
		 OW=2
		}
	 If (OW = 0) or (OW = 1) ; it is a file, so we have to read into var Text
		{
		 Text := (SubStr(Text,1,1)="!") ? (SubStr(Text,2)) : Text
		 FileName=%Text% ; Store FileName
		 FileRead, Text, %Text% ; Read file and return as var Text
		 If (ErrorLevel > 0)
			{
			 MsgBox, 48, TF Lib Error, % "Can not read " FileName
			 ExitApp
			}
		}
	 Return
	}


; ALG_TF__MakeMatchList()
; Purpose:
; Make a MatchList which is used in various functions
; Using a MatchList gives greater flexibility so you can process multiple
; sections of lines in one go avoiding repetitive fileread/append actions
; For TF 3.4 added COL = 0/1 option (for ALG_TF_Col* functions) and CallFunc for
; all ALG_TF_* functions to facilitate bug tracking
ALG_TF__MakeMatchList(Text, Start = 1, End = 0, Col = 0, CallFunc = "Not available")
	{
	 ErrorList=
	 (join|
Error 01: Invalid StartLine parameter (non numerical character)`nFunction used: %CallFunc%
Error 02: Invalid EndLine parameter (non numerical character)`nFunction used: %CallFunc%
Error 03: Invalid StartLine parameter (only one + allowed)`nFunction used: %CallFunc%
	 )
	 StringSplit, ErrorMessage, ErrorList, |
	 Error = 0

	 If (Col = 1)
		{
		 LongestLine:=ALG_TF_Stat(Text)
		 If (End > LongestLine) or (End = 1) ; FIXITHERE BUG
			End:=LongestLine
		}

	 ALG_TF_MatchList= ; just to be sure
	 If (Start = 0 or Start = "")
		Start = 1

	 ; some basic error checking

	 ; error: only digits - and + allowed
	 If (RegExReplace(Start, "[ 0-9+\-\,]", "") <> "")
		 Error = 1

	 If (RegExReplace(End, "[0-9 ]", "") <> "")
		 Error = 2

	 ; error: only one + allowed
	 If (ALG_TF_Count(Start,"+") > 1)
		 Error = 3

	 If (Error > 0 )
		{
		 MsgBox, 48, TF Lib Error, % ErrorMessage%Error%
		 ExitApp
		}

	 ; Option #0 [ added 30-Oct-2010 ]
	 ; Startline has negative value so process X last lines of file
	 ; endline parameter ignored

	 If (Start < 0) ; remove last X lines from file, endline parameter ignored
		{
		 Start:=ALG_TF_CountLines(Text) + Start + 1
		 End=0 ; now continue
		}

	 ; Option #1
	 ; StartLine has + character indicating startline + incremental processing.
	 ; EndLine will be used
	 ; Make ALG_TF_MatchList

	 IfInString, Start, `+
		{
		 If (End = 0 or End = "") ; determine number of lines
			End:= ALG_TF_Count(Text, "`n") + 1
		 StringSplit, Section, Start, `, ; we need to create a new "ALG_TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `+
			 LoopSection:=End + 1 - SectionLines1
			 Counter=0
			 	 ALG_TF_MatchList .= SectionLines1 ","
			 Loop, %LoopSection%
				{
				 If (A_Index >= End) ;
					Break
				 If (Counter = (SectionLines2-1)) ; counter is smaller than the incremental value so skip
					{
					 ALG_TF_MatchList .= (SectionLines1 + A_Index) ","
					 Counter=0
					}
				 Else
					Counter++
				}
			}
		 StringTrimRight, ALG_TF_MatchList, ALG_TF_MatchList, 1 ; remove trailing ,
		 Return ALG_TF_MatchList
		}

	 ; Option #2
	 ; StartLine has - character indicating from-to, COULD be multiple sections.
	 ; EndLine will be ignored
	 ; Make ALG_TF_MatchList

	 IfInString, Start, `-
		{
		 StringSplit, Section, Start, `, ; we need to create a new "ALG_TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `-
			 LoopSection:=SectionLines2 + 1 - SectionLines1
			 Loop, %LoopSection%
				{
				 ALG_TF_MatchList .= (SectionLines1 - 1 + A_Index) ","
				}
			}
		 StringTrimRight, ALG_TF_MatchList, ALG_TF_MatchList, 1 ; remove trailing ,
		 Return ALG_TF_MatchList
		}

	 ; Option #3
	 ; StartLine has comma indicating multiple lines.
	 ; EndLine will be ignored

	 IfInString, Start, `,
		{
		 ALG_TF_MatchList:=Start
		 Return ALG_TF_MatchList
		}

	 ; Option #4
	 ; parameters passed on as StartLine, EndLine.
	 ; Make ALG_TF_MatchList from StartLine to EndLine

	 If (End = 0 or End = "") ; determine number of lines
			End:= ALG_TF_Count(Text, "`n") + 1
	 LoopTimes:=End-Start
	 Loop, %LoopTimes%
		{
		 ALG_TF_MatchList .= (Start - 1 + A_Index) ","
		}
	 ALG_TF_MatchList .= End ","
	 StringTrimRight, ALG_TF_MatchList, ALG_TF_MatchList, 1 ; remove trailing ,
	 Return ALG_TF_MatchList
	}

; added for TF 3.4 col functions - currently only gets longest line may change in future

ALG_TF_Count(String, Char)
	{
	StringReplace, String, String, %Char%,, UseErrorLevel
	Return ErrorLevel
	}


ALG_TF_Stat(Text)
	{
	 ALG_TF_GetData(OW, Text, FileName)
	 Sort, Text, f _AscendingLinesL
	 Pos:=InStr(Text,"`n")-1
	 Return pos
	}


; Write to file or return variable depending on input
ALG_TF_ReturnOutPut(OW, Text, FileName, TrimTrailing = 1, CreateNewFile = 0) {
	If (OW = 0) ; input was file, file_copy will be created, if it already exist file_copy will be overwritten
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
			{
			 If (CreateNewFile = 1) ; CreateNewFile used for ALG_TF_SplitFileBy* and others
				{
				 OW = 1
				 Goto ALG_TF_CreateNewFile
				}
			 Else
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_WorkingDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "_copy." Ext, % Dir "\backup\" Name "_copy.bak", 1
		 FileDelete, % Dir "\" Name "_copy." Ext
		 FileAppend, %Text%, % Dir "\" Name "_copy." Ext
		 Return Errorlevel ? False : True
		}
	 ALG_TF_CreateNewFile:
	 If (OW = 1) ; input was file, will be overwritten by output
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
			{
			If (CreateNewFile = 0) ; CreateNewFile used for ALG_TF_SplitFileBy* and others
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_WorkingDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "." Ext, % Dir "\backup\" Name ".bak", 1
		 FileDelete, % Dir "\" Name "." Ext
		 FileAppend, %Text%, % Dir "\" Name "." Ext
		 Return Errorlevel ? False : True
		}
	If (OW = 2) ; input was var, return variable
		{
		 If (TrimTrailing = 1)
			StringTrimRight, Text, Text, 1 ; remove trailing `n
		 Return Text
		}
	}
ALG_TF_CountLines(Text)
	{
	 TF_GetData(OW, Text, FileName)
	 StringReplace, Text, Text, `n, `n, UseErrorLevel
	 Return ErrorLevel + 1
	}
















	
#Include %A_ScriptDir%\Includes\RichCode.ahk
#Include %A_ScriptDir%\Includes\Editor.ahk

